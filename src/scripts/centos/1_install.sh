#!/bin/bash

# Expected parameters
DOWNLOAD_URL=${DOWNLOAD_URL}

mkdir -p /etc/prometheus
mkdir -p /etc/prometheus/tgroups
mkdir -p /usr/share/prometheus

# Cleanup and stop service if running
rm -fR /tmp/prometheus*
if [ $(pidof prometheus) ]; then
  systemctl stop prometheus
fi

# Install prometheus
curl -Lo /tmp/prometheus.tar.gz "$DOWNLOAD_URL"
tar -xvzf /tmp/prometheus.tar.gz -C /tmp/

FOLDER_NAME=$(find /tmp -type d -name "prometheus*")
cp $FOLDER_NAME/prometheus /bin/prometheus
cp $FOLDER_NAME/promtool /bin/promtool
cp -r $FOLDER_NAME/console_libraries /usr/share/prometheus
cp -r $FOLDER_NAME/consoles /usr/share/prometheus

# Only copy default config file of none exists
if [ ! -f /etc/prometheus/prometheus.yml ]; then
  cp $FOLDER_NAME/prometheus.yml /etc/prometheus/prometheus.yml
fi

cat <<EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Server
Documentation=https://prometheus.io/docs/introduction/overview/
After=network-online.target

[Service]
User=root
Restart=on-failure
ExecStart=/bin/prometheus\
 -config.file "/etc/prometheus/prometheus.yml"\
 -storage.local.path "/mnt/prometheus"\
 -web.console.libraries "/usr/share/prometheus/console_libraries"\
 -web.console.templates "/usr/share/prometheus/consoles" \
 -web.listen-address "0.0.0.0:9090"

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus
