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

module "vpc_mod_shenzhen" {
  source = "../vpc_mod"

  providers = {
    alicloud = alicloud.shenzhen
  }
}

module "vpc_mod_hangzhou" {
  source = "../vpc_mod"

  providers = {
    alicloud = alicloud.hangzhou
  }
}

module "vpc_mod_hongkong" {
  source = "../vpc_mod"

  providers = {
    alicloud = alicloud.hongkong
  }
}
