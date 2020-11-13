#!/bin/bash

action=""
private_ip=""
public_ip=""
hostname=""
ssh_filename=""

function help() {
    echo "(action)   -a \${action} is insert or delete"
    echo "(internal) -i \${private_ip}"
    echo "(external) -e \${public_ip}"
    echo "(target)   -t \${hostname}"
    echo "(filename) -f \${ssh_filename}"
}

while getopts ":a:i:e:t:f:h" opt
do
    case "${opt}" in
        a)
            action=${OPTARG}
            ;;
        i)
            private_ip=${OPTARG}
            ;;
        e)
            public_ip=${OPTARG}
            ;;
        t)
            hostname=${OPTARG}
            ;;
        f)
            ssh_filename=${OPTARG}
            ;;
        h)
            help
            exit 0
            ;;
        *)
            echo "unknow ${OPTARG}"
            help
            exit -1
            ;;
    esac
done

if [ -z "${action}" ]; then
    echo "action should not be empty"
    exit -1
fi

if [ -z "${private_ip}" ]; then
    echo "private ip should not be empty"
    exit -1
fi

if [ -z "${ssh_filename}" ]; then
    echo "ssh filename should not be empty"
    exit -1
fi

function main() {
    case "${action}" in
        i|insert)
            insert
            ;;
        d|delete)
            delete
            ;;
        *)
            echo "unknow action(${action})"
            help
            exit -1
            ;;
    esac
}

function insert() {

    cat >> ${CONFIG_FILE} << EOF
# private ip: ${private_ip}
Host ${hostname}
    HostName ${public_ip}
    IdentityFile ~/.ssh/private/andrew_id_rsa
    StrictHostKeyChecking no

EOF

    chmod 600 ${CONFIG_FILE}
}

function delete() {
    if [ ! -f "${CONFIG_FILE}" ]; then
        return
    fi
    sed -i "/${private_ip}/,+5d" ${CONFIG_FILE}
}

CONFIG_FILE=${HOME}/.ssh/extra/${ssh_filename}.conf

main
