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


### upgrade to terraform 0.13

* more config: ```~/.terraformrc``` (should replace $HOME with actual path string)

```
provider_installation {
  filesystem_mirror {
    path    = "$HOME/.terraform.d/plugins"
    include = ["aliyun/alicloud", "tencentcloudstack/tencentcloud"]
  }
  direct {
    exclude = ["aliyun/alicloud", "tencentcloudstack/tencentcloud"]
  }
}
```

* plugins should be managed in structured directories

```
$HOME/.terraform.d/plugins
└── registry.terraform.io
    ├── aliyun
    │   └── alicloud
    │       └── terraform-provider-alicloud_1.103.1_linux_amd64.zip
    └── tencentcloudstack
        └── tencentcloud
            └── terraform-provider-tencentcloud_1.46.4_linux_amd64.zip
```

* provider demystified
    * the official registry is registry.terraform.io (the default namespace is hashcorp?)
    * for provider alicloud (https://registry.terraform.io/providers/aliyun/alicloud/latest)
        * the namespace is aliyun
        * the type is alicloud

    * for provider tencetncloud (https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest)
        * the namespace is tencentcloudstack
        * the type is tencentcloud

* terraform settings in .tf files:

```
terraform {
  required_providers {
    alicloud = {
      source = "aliyun/alicloud"
      version = "1.103.1"
    }
  }
  required_version = ">= 0.13"
}
```

* use ```terraform state replace-provider -- '-/alicloud' 'aliyun/alicloud'``` to correct state files
