#!/bin/bash -x

CONFIG_TEMPLATE="${CONFIG_TEMPLATE}"
TEMPLATE_VARS=${TEMPLATE_VARS:-'{}'}

PRIMARY_NIC=$(route -n | grep -E "^0.0.0.0" | awk '{print $8}')
PRIMARY_ADDR=$(ip addr show dev $PRIMARY_NIC | grep -E "inet " | awk '{print $2}' | cut -d '/' -f1)

for KEY in `echo $TEMPLATE_VARS | jq -r '. as $in| keys[]'`; do
  VAL=$(echo $TEMPLATE_VARS | jq -r .$KEY)
  export $KEY=$VAL
done


CONFIG=$(eval "echo -e \"$CONFIG_TEMPLATE\"")
echo "$CONFIG" > /etc/prometheus/prometheus.yml

chown root:root /etc/prometheus/prometheus.yml
chmod 600 /etc/prometheus/prometheus.yml

service prometheus restart
