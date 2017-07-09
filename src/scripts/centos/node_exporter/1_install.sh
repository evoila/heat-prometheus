#!/bin/bash

# Expected parameters
DOWNLOAD_URL=${DOWNLOAD_URL}

# Install prometheus
curl -Lo /tmp/node_exporter.tar.gz "$DOWNLOAD_URL"
tar -xvzf /tmp/node_exporter.tar.gz -C /tmp/

FOLDER_NAME=$(find /tmp -type d -name "node_exporter*")
cp $FOLDER_NAME/node_exporter /bin/node_exporter

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
