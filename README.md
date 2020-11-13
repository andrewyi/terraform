***please tell me if there are any credentials in this repo***

# useage:

### prerequests

* install terraform 0.12

* sample config: ```~/.terraformrc```

```
plugin_cache_dir   = "$HOME/.terraform.d/plugin-cache"
disable_checkpoint = true
```

* install providers plugins: ```~/.terraform.d/plugins/``` (should be decompressed)

* all binaries could be donwloaded from ```https://releases.hashicorp.com/```

### provider settings

* aliyun:

```
export ALICLOUD_ACCESS_KEY=""
export ALICLOUD_SECRET_KEY=""
```

* tencentcloud

```
export TENCENTCLOUD_SECRET_ID=""
export TENCENTCLOUD_SECRET_KEY=""
```

### run:

* ```./aliyun/region_infra/keys```
    * will create ssh key in shenzhen/hangzhou/hongkong
    * ssh file ```~/.ssh/private/andrew_id_rsa``` should exists

* ```./aliyun/region_infra/vpcs```
    * will create vpcs in shenzhen/hangzhou/hongkong

* ```./aliyun/pocservers```
    * will create pocservers set in terraform.tfvars in shenzhen

* ```./aliyun/hkrelayer```
    * will create a socks5 proxy server hongkong (using trojan)
