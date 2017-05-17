#!/bin/bash

# Expected parameters
VERSION=${VERSION:-0.10.0}

mkdir -p /etc/prometheus

# Install prometheus
curl -Lo /tmp/mysqld_exporter.tar.gz https://github.com/prometheus/mysqld_exporter/releases/download/v$VERSION/mysqld_exporter-$VERSION.linux-amd64.tar.gz
tar -xvzf /tmp/mysqld_exporter.tar.gz -C /tmp/

cp /tmp/mysqld_exporter-$VERSION.linux-amd64/mysqld_exporter /bin/mysqld_exporter

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
