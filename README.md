# aliyun ram root

* 授予最高权限并获取以下信息
AccessKey ID 
AccessKeySecret 

* 配置环境变量
export ALICLOUD_ACCESS_KEY=""
export ALICLOUD_SECRET_KEY=""



# 配置terraform

* 配置文件 ~/.terraformrc
plugin_cache_dir   = "$HOME/.terraform.d/plugin-cache"
disable_checkpoint = true

* 手动下载plugin
https://releases.hashicorp.com/terraform-provider-alicloud/1.80.0/terraform-provider-alicloud_1.80.0_linux_386.zip

mkdir -p ~/.terraform.d/plugins
将下载好的terraform-provider-alicloud_1.80.0_linux_amd64.zip解压并放入



# download terraform artifacts (plugins...)

* 资源下载地址 https://releases.hashicorp.com/

https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip



# 有的文件建议放入git管理，但是因为设置到私有信息，不在此仓库展示
