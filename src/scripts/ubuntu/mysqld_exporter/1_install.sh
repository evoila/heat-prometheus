#!/bin/bash

# Expected parameters
DOWNLOAD_URL=${DOWNLOAD_URL}

mkdir -p /etc/prometheus

# Install prometheus
curl -Lo /tmp/mysqld_exporter.tar.gz "$DOWNLOAD_URL"
tar -xvzf /tmp/mysqld_exporter.tar.gz -C /tmp/

FOLDER_NAME=$(find /tmp -type d -name "mysqld_exporter*")
cp $FOLDER_NAME/mysqld_exporter /bin/mysqld_exporter

cat <<EOF > /etc/systemd/system/mysqld_exporter.service
[Unit]
Description=Prometheus mysqld exporter
After=local-fs.target network-online.target network.target
Wants=local-fs.target network-online.target network.target

[Service]
ExecStart=/bin/mysqld_exporter -config.my-cnf /etc/prometheus/my.cnf
Type=simple

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable mysqld_exporter
systemctl start mysqld_exporter
