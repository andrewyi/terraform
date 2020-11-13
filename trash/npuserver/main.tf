locals {
  ssh_key_name = "andrew_id_rsa"

  instances = {
    "shenzhen" : [
      {
        "name" : "npuserver",
        "os" : "ubuntu18.04",
        "instance_type" : "gn6i",
        "disk_category" : "cloud_ssd",
        "disk_size" : 100,
      }
    ]
  }
}

provider "alicloud" {
  alias  = "shenzhen"
  region = "cn-shenzhen"
}

module "ecs_mod_shenzhen" {
  source = "../modules/ecs"

  ssh_key_name   = local.ssh_key_name
  required_nodes = local.instances["shenzhen"]

  providers = {
    alicloud = alicloud.shenzhen
  }
}

output "ecs_mod_shenzhen_output" {
  value = module.ecs_mod_shenzhen.all_instances
}
