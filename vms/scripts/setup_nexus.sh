#!/bin/bash

NEXUS_VERSION=2.13.0-01
user="nexus"
group="nexus"


echo "deb http://ftp.debian.org/debian/ jessie-backports main contrib non-free" > /etc/apt/sources.list.d/backports.list
apt-get update
apt-get install -t jessie-backports -y openjdk-8-jre-headless ca-certificates-java vim-nox unzip curl

addgroup --system "$group" --quiet

adduser --system --home /var/lib/nexus \
  --ingroup "$group" --disabled-password \
  --shell /bin/false "$user"

mkdir -p /var/lib/nexus/sonatype_work
chown $user:$group -R /var/lib/nexus
cat > /etc/systemd/system/nexus.service <<EOL
[Unit]
Description=Nexus Repository Manager OSS
After=network.target

[Service]
ExecStart=/usr/bin/java \
  -Dnexus-work=/var/lib/nexus/sonatype_work -Dnexus-webapp-context-path=/ \
  -Xms256m -Xmx768m \
  -cp 'conf/:lib/*' \
  -server -XX:MaxPermSize=192m -Djava.net.preferIPv4Stack=true \
  org.sonatype.nexus.bootstrap.Launcher ./conf/jetty.xml ./conf/jetty-requestlog.xml
WorkingDirectory=/usr/share/nexus
User=nexus
Group=nexus

# When a JVM receives a SIGTERM signal it exits with 143.
SuccessExitStatus=143

# Capture stderr/stdout via systemd journal.
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOL

curl -L https://download.sonatype.com/nexus/oss/nexus-$NEXUS_VERSION-bundle.tar.gz | tar xz -C /tmp nexus-$NEXUS_VERSION
mv /tmp/nexus-$NEXUS_VERSION /usr/share/nexus
chown $user:$group -R /usr/share/nexus
rm -rf /tmp/nexus-$NEXUS_VERSION

wget https://github.com/rundeck/nexus-rundeck-plugin/releases/download/nexus-rundeck-plugin-1.3/nexus-rundeck-plugin-1.3-bundle.zip
unzip nexus-rundeck-plugin-1.3-bundle.zip
mv nexus-rundeck-plugin-1.3 /var/lib/nexus/sonatype_work/plugin-repository
chown nexus:nexus -R /var/lib/nexus/sonatype_work/plugin-repository

systemctl daemon-reload

systemctl enable nexus
systemctl start nexus
