# init

```
python3 -m venv venv
source ./venv/bin/activate
pip install ansible
```

# run

```
source ./venv/bin/activate
ansible-playbook -i hosts.ini site.yaml
```

# custmize

```
source ./venv/bin/activate
ansible-playbook -i hosts.ini site.yaml # append -t k8s to run k8s role only
```

# roles

* ansible_pkgs
    * install ansible packages, it's ok to skip this

* apt_repo
    * mean to update packages sources, but do nothing now

* chrony
    * install chrony and set local time to servers

* hosts
    * update server hostname to ssh host

* kubernetes
    * install k8s

* ssh_access
    * upload ssh pubkey and disable root password access
