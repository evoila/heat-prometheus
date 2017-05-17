#!/bin/bash

JOB_DEFINITIONS=${JOB_DEFINITIONS}

PRIMARY_NIC=$(route -n | grep -E "^0.0.0.0" | awk '{print $8}')
PRIMARY_ADDR=$(ip addr show dev $PRIMARY_NIC | grep -E "inet " | awk '{print $2}' | cut -d '/' -f1)

cat <<EOF > /etc/prometheus/prometheus.yml
global:
  scrape_interval:     10s
  evaluation_interval: 10s
scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['$PRIMARY_ADDR:9090']
  - job_name: 'dummy'
    file_sd_configs:
      - files: ['/etc/prometheus/tgroups/*.yaml']
EOF

service prometheus restart
