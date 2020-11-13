terraform {
  required_providers {
    alicloud = {
      source = "aliyun/alicloud"
      version = "1.103.1"
    }
  }
  required_version = ">= 0.13"
}

variable "public_key_file_name" {
  type    = string
  default = "andrew_id_rsa.pub"
}

variable "key_name" {
  type    = string
  default = "andrew_id_rsa"
}

provider "alicloud" {
  alias  = "shenzhen"
  region = "cn-shenzhen"
}

provider "alicloud" {
  alias  = "hangzhou"
  region = "cn-hangzhou"
}

provider "alicloud" {
  alias  = "hongkong"
  region = "cn-hongkong"
}

module "ssh_key_mod_shenzhen" {
  source = "../ssh_key_mod"

  public_key_file_name = var.public_key_file_name
  key_name             = var.key_name

  providers = {
    alicloud = alicloud.shenzhen
  }
}

module "ssh_key_mod_hangzhou" {
  source = "../ssh_key_mod"

  public_key_file_name = var.public_key_file_name
  key_name             = var.key_name

  providers = {
    alicloud = alicloud.hangzhou
  }
}

module "ssh_key_mod_hongkong" {
  source = "../ssh_key_mod"

  public_key_file_name = var.public_key_file_name
  key_name             = var.key_name

  providers = {
    alicloud = alicloud.hongkong
  }
}
