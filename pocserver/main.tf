locals {
  ssh_key_name = "andrew_id_rsa"

  instances = {
    "shenzhen" : [
      {
        "name" : "pocserver",
        "os" : "ubuntu18.04",
        "instance_type" : "c6e",
        "disk_category" : "cloud_essd",
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

resource "null_resource" "update_ssh_config" {
  triggers = {
    pocserver_ip = module.ecs_mod_shenzhen.all_instances["pocserver"]
  }

  provisioner "local-exec" {
    command = "sed -i '/Host pocserver/,+1cHost pocserver\\n    HostName        ${module.ecs_mod_shenzhen.all_instances["pocserver"]}' ~/.ssh/config"
    interpreter = ["/bin/bash", "-c"]
  }
}
