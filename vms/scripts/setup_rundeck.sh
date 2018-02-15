#!/bin/bash

apt-get update
apt-get install -y apt-transport-https
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61
echo "deb http://ftp.debian.org/debian/ jessie-backports main contrib non-free" > /etc/apt/sources.list.d/backports.list
echo "deb https://dl.bintray.com/rundeck/rundeck-deb /" > /etc/apt/sources.list.d/rundeck.list
apt-get update
apt-get install -t jessie-backports -y openjdk-8-jre-headless rundeck vim-nox
sed -i 's/localhost/192.168.33.50/g' /etc/rundeck/rundeck-config.properties
sed -i 's=/var/rundeck/projects=/var/lib/rundeck/projects=g' /etc/rundeck/framework.properties
cat >> /etc/rundeck/framework.properties <<EOF
# ----------------------------------------------------------------
# nexus-steps plugin
# ----------------------------------------------------------------

framework.plugin.WorkflowStep.nexus-deliver-artifact-step.nexus=http://192.168.33.52:8081
framework.plugin.WorkflowStep.nexus-deliver-artifact-step.nexusUser=deployment
framework.plugin.WorkflowStep.nexus-deliver-artifact-step.nexusPassword=deployment123
EOF
cp /vagrant/nexus-step-plugins-1.0.1.jar /var/lib/rundeck/libext

cat >> /etc/rundeck/deploy.aclpolicy <<EOF
# create or append this to a .aclpolicy file
---
by:
  group: deploy
context:
  project: meetup
for:
  resource:
  - allow: read
    equals:
      kind: event
description: generated
EOF

cat >> /etc/rundeck/senior.aclpolicy <<EOF
# create or append this to a .aclpolicy file
---
by:
  group: senior
context:
  project: meetup
for:
  node:
  - allow:
    - read
    - run
    equals:
      nodename: stage
description: generated
EOF

cat >> /etc/rundeck/ops.aclpolicy <<EOF
# create or append this to a .aclpolicy file
---
by:
  group: ops
context:
  project: meetup
for:
  job:
  - allow:
    - read
    - run
    match:
      name: .*
      group: ''
description: generated
# create or append this to a .aclpolicy file
---
by:
  group: ops
context:
  project: meetup
for:
  adhoc:
  - allow:
    - read
    - run
    - kill
description: generated
# create or append this to a .aclpolicy file
---
by:
  group: ops
context:
  project: meetup
for:
  node:
  - allow:
    - read
    - run
description: generated
# create or append this to a .aclpolicy file
---
by:
  group: ops
context:
  project: meetup
for:
  resource:
  - allow: read
    equals:
      kind: node
description: generated
EOF

cat >> /etc/rundeck/realm.properties <<EOF
jenkins:jenkins,user,deploy
junior:junior,user,deploy
senior:senior,user,deploy,senior
ops:ops,user,deploy,ops
EOF

mkdir /var/lib/rundeck/projects
chown rundeck:rundeck /var/lib/rundeck/projects
systemctl enable rundeckd
systemctl start rundeckd
