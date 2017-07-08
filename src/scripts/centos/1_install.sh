#!/bin/bash

# Expected parameters
DOWNLOAD_URL=${DOWNLOAD_URL}

mkdir -p /etc/prometheus
mkdir -p /etc/prometheus/tgroups
mkdir -p /usr/share/prometheus

# Install prometheus
curl -Lo /tmp/prometheus.tar.gz "$DOWNLOAD_URL"
tar -xvzf /tmp/prometheus.tar.gz -C /tmp/

cp /tmp/prometheus-1.6.1.linux-amd64/prometheus /bin/prometheus
cp /tmp/prometheus-1.6.1.linux-amd64/promtool /bin/promtool
cp /tmp/prometheus-1.6.1.linux-amd64/prometheus.yml /etc/prometheus/prometheus.yml
cp -r /tmp/prometheus-1.6.1.linux-amd64/console_libraries /usr/share/prometheus
cp -r /tmp/prometheus-1.6.1.linux-amd64/consoles /usr/share/prometheus

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
