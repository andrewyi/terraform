variable "instance_names" {
  type    = list(string)
  default = ["mybdpocctl", "mybdpocfwd"]
}

terraform {
  required_providers {
    baiducloud = {
      source  = "baidubce/baiducloud"
      version = "1.11.0"
    }
  }
  required_version = "= 0.14.8"
}

provider "baiducloud" {
  region = "gz"
  alias  = "guangzhou"
}

module "servers" {
  source = "./bcc"

  for_each      = toset(var.instance_names)
  instance_name = each.key

  providers = {
    baiducloud = baiducloud.guangzhou
  }
}

/* // not working
output "instances_info" {
  depends_on = [
    module.servers.instance_info
  ]

  value = module.servers.instance_info
}
*/
