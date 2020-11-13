#!/bin/bash

hostname=$1
public_ip=$2
private_ip=$3

CONFIG_FILE=${HOME}/.ssh/extra/pocservers.conf

cat >> ${CONFIG_FILE} << EOF
# private ip: ${private_ip}
Host ${hostname}
    HostName ${public_ip}
    IdentityFile ~/.ssh/andrew_private/andrew_id_rsa
    StrictHostKeyChecking no

EOF

chmod 600 ${CONFIG_FILE}
