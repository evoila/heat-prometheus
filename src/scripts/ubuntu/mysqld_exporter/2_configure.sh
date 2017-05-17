#!/bin/bash

HOST=${HOST}
USER=${USER:-root}
PASS=${PASS}

cat <<EOF > /etc/prometheus/my.cnf
[client]
EOF

HOST_LINE=''
if [ ! -z $HOST ]; then
  cat <<EOF >> /etc/prometheus/my.cnf
host=$HOST
EOF
fi

cat <<EOF >> /etc/prometheus/my.cnf
user=$USER
password=$PASS
EOF

service mysqld_exporter restart
