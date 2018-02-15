#!/bin/bash

echo "deb http://ftp.debian.org/debian/ jessie-backports main contrib non-free" > /etc/apt/sources.list.d/backports.list
apt-get update
apt-get install -t jessie-backports -y openjdk-8-jre-headless jq vim-nox curl

cat > /etc/systemd/system/demo.service <<EOL
[Unit]
Description=Devops Meetup Demo Application
After=network.target

[Service]
ExecStart=/usr/bin/java -jar /home/vagrant/demo.jar
User=vagrant
Group=vagrant

# When a JVM receives a SIGTERM signal it exits with 143.
SuccessExitStatus=143

# Capture stderr/stdout via systemd journal.
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOL

systemctl daemon-reload
systemctl enable demo
