#!/bin/bash

# Expected parameters
VERSION=${VERSION:-0.14.0}

# Install prometheus
curl -Lo /tmp/node_exporter.tar.gz https://github.com/prometheus/node_exporter/releases/download/v$VERSION/node_exporter-$VERSION.linux-amd64.tar.gz
tar -xvzf /tmp/node_exporter.tar.gz -C /tmp/

cp /tmp/node_exporter-$VERSION.linux-amd64/node_exporter /bin/node_exporter

cat <<EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Prometheus node exporter
After=local-fs.target network-online.target network.target
Wants=local-fs.target network-online.target network.target

[Service]
ExecStart=/bin/node_exporter
Type=simple

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable node_exporter

service node_exporter start
