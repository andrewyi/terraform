locals {
  ssh_key_name = "andrew_id_rsa"

  instances = {
    "shenzhen" : [
      {
        "name" : "pocserver",
        "os" : "ubuntu18.04",
        "instance_type" : "t6",
        "disk_category" : "cloud_efficiency",
        "disk_size" : 40,
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
    command = "echo -e 'Host pocserver\\n    HostName ${module.ecs_mod_shenzhen.all_instances["pocserver"]}\\n    IdentityFile ~/.ssh/andrew_private/andrew_id_rsa' > ~/.ssh/extra/pocserver.conf && chmod 600 ~/.ssh/extra/pocserver.conf"
    interpreter = ["/bin/bash", "-c"]
  }

  provisioner "local-exec" {
    when = destroy
    command = "rm -f ~/.ssh/extra/pocserver.conf"
    interpreter = ["/bin/bash", "-c"]
  }
}
