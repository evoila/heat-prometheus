#!/bin/bash

JOB_NAME=${JOB_NAME}
ADDRESSES=${ADDRESSES}
NAMES=${NAMES}

echo "Params:"
echo "JOB_NAME: $JOB_NAME"
echo "ADDRESSES: $ADDRESSES"
echo "NAMES: $NAMES"

# Clear file
truncate -s 0 /etc/prometheus/tgroups/$JOB_NAME.yaml
echo "Cleared file /etc/prometheus/tgroups/$JOB_NAME.yaml"

# Write targets
LENGTH=$(echo ${ADDRESSES} | jq 'length')
LAST_INDEX=$((LENGTH-1))

echo "LENGTH: $LENGTH"
echo "LAST_INDEX: $LAST_INDEX"

for I in `seq 0 $LAST_INDEX`; do
  ADDR=$(echo $ADDRESSES | jq -r ".[$I]" )
  NAME=$(echo $NAMES | jq -r ".[$I]" )
  cat <<EOF >> /etc/prometheus/tgroups/$JOB_NAME.yaml
- targets: ["$ADDR"]
  labels:
    job: '$JOB_NAME'
    instance: "$NAME"
EOF
done
