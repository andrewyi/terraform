variable "ssh_key_name" {
  type = string
}

variable "instances" {
  type = map(
    list(
      object(
        {
          name          = string
          os            = string
          instance_type = string
        }
      )
    )
  )
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
  alias  = "shanghai"
  region = "cn-shanghai"
}

provider "alicloud" {
  alias  = "beijing"
  region = "cn-beijing"
}

provider "alicloud" {
  alias  = "chengdu"
  region = "cn-chengdu"
}

provider "alicloud" {
  alias  = "qingdao"
  region = "cn-qingdao"
}

module "ecs_mod_shenzhen" {
  source = "../ecs_mod"

  ssh_key_name   = var.ssh_key_name
  required_nodes = var.instances["shenzhen"]

  providers = {
    alicloud = alicloud.shenzhen
  }
}

output "ecs_mod_shenzhen_output" {
  value = module.ecs_mod_shenzhen.all_instances
}

/*
module "ecs_mod_hangzhou" {
  source = "../ecs_mod"

  ssh_key_name   = var.ssh_key_name
  required_nodes = var.instances["hangzhou"]

  providers = {
    alicloud = alicloud.hangzhou
  }
}

output "ecs_mod_hangzhou_output" {
  value = module.ecs_mod_hangzhou.all_instances
}
*/

module "ecs_mod_shanghai" {
  source = "../ecs_mod"

  ssh_key_name   = var.ssh_key_name
  required_nodes = var.instances["shanghai"]

  providers = {
    alicloud = alicloud.shanghai
  }
}

output "ecs_mod_shanghai_output" {
  value = module.ecs_mod_shanghai.all_instances
}

module "ecs_mod_beijing" {
  source = "../ecs_mod"

  ssh_key_name   = var.ssh_key_name
  required_nodes = var.instances["beijing"]

  providers = {
    alicloud = alicloud.beijing
  }
}

output "ecs_mod_beijing_output" {
  value = module.ecs_mod_beijing.all_instances
}

/*
module "ecs_mod_chengdu" {
  source = "../ecs_mod"

  ssh_key_name   = var.ssh_key_name
  required_nodes = var.instances["chengdu"]

  providers = {
    alicloud = alicloud.chengdu
  }
}

module "ecs_mod_qingdao" {
  source = "../ecs_mod"

  ssh_key_name   = var.ssh_key_name
  required_nodes = var.instances["qingdao"]

  providers = {
    alicloud = alicloud.qingdao
  }
}
*/
