#!/usr/bin/env python3

import os
import json


FILE_NAME = './instances.json'


def run_script(hostname, public_ip, private_ip):
    cmd = 'bash ../../ssh_conf.sh -a i -t {} -e {} -i {} -f mybdpoc'.format(
            hostname, public_ip, private_ip)
    os.system(cmd)


def parse_hosts(data):
    for k, v in data.items():
        public_ip = v.get("public_ip")
        private_ip = v.get("private_ip")
        run_script(k, public_ip, private_ip)


def main():
    data = {}
    try:
        with open(FILE_NAME, 'r') as f:
            data.update(json.loads(f.read()))
    except:
        raise

    parse_hosts(data.get('created', {}).get('value', {}))


if __name__ == '__main__':
    main()
