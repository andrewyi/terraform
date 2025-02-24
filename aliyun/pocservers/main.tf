variable "instances" {
  type = list(
    object({
      host_name     = string
      os            = string
      instance_type = string
      disk_category = string
    })
  )
}

terraform {
  required_providers {
    alicloud = {
      source = "aliyun/alicloud"
      version = "1.118.0"
    }
  }
  required_version = "= 0.14.8"
}

provider "alicloud" {
  region = "cn-shenzhen"
}

locals {
  vpc_id               = data.alicloud_vpcs.playground.ids[0]
  default_sec_group_id = data.alicloud_security_groups.default_group.ids[0]
  vswitch_zone2id = {
    for s in data.alicloud_vswitches.switches.vswitches : s.zone_id => s.id
  }
  os_image_map = {
    "ubuntu_18_04": data.alicloud_images.ubuntu_18_04.ids[0],
    "centos_7_06": data.alicloud_images.centos_7_06.ids[0],
  }
  ssh_key     = data.alicloud_key_pairs.key.ids[0]

  itype_map = {
    "t6" : data.alicloud_instance_types.t6.ids[0],
    "hfc7" : data.alicloud_instance_types.hfc7.ids[0],
  }
  azone_map = {
    "t6" : data.alicloud_instance_types.t6.instance_types[0].availability_zones[0],
    "hfc7" : data.alicloud_instance_types.hfc7.instance_types[0].availability_zones[0],
  }
}

data "alicloud_zones" "zones" {
}

data "alicloud_key_pairs" "key" {
  name_regex = "^andrew_id_rsa$"
}

data "alicloud_images" "ubuntu_18_04" {
  owners      = "system"
  name_regex  = "^ubuntu_18_04_x64"
  most_recent = true
}

data "alicloud_images" "centos_7_06" {
  owners      = "system"
  name_regex  = "^centos_7_06_64"
  most_recent = true
}

data "alicloud_vpcs" "playground" {
  name_regex = "^playground$"
  status     = "Available"
}

data "alicloud_security_groups" "default_group" {
  name_regex = "^default_group$"
  vpc_id     = local.vpc_id
}

data "alicloud_vswitches" "switches" {
  vpc_id = local.vpc_id
}

data "alicloud_instance_types" "hfc7" {
  // 0.942 /时
  cpu_core_count       = 4
  memory_size          = 8
  instance_type_family = "ecs.hfc7"
  instance_charge_type = "PostPaid"
  network_type         = "Vpc"
}

data "alicloud_instance_types" "t6" {
  // 0.236 /时
  cpu_core_count       = 2
  memory_size          = 4
  instance_type_family = "ecs.t6"
  instance_charge_type = "PostPaid"
  network_type         = "Vpc"
}

resource "alicloud_instance" "pocservers" {
  instance_charge_type       = "PostPaid"
  internet_charge_type       = "PayByTraffic"
  internet_max_bandwidth_out = 100
  security_groups            = [local.default_sec_group_id]
  key_name                   = local.ssh_key
  system_disk_size           = 40


  for_each = {
    for i in range(length(var.instances)) : i => var.instances[i]
  }
  instance_type         = local.itype_map[each.value["instance_type"]]
  vswitch_id            = local.vswitch_zone2id[
    local.azone_map[each.value["instance_type"]]]
  system_disk_category  = each.value["disk_category"]
  image_id              = local.os_image_map[each.value["os"]]
  host_name             = each.value["host_name"]
  instance_name         = each.value["host_name"]

  provisioner "local-exec" {
    command     = "bash ../../ssh_conf.sh -a i -t ${self.host_name} -e ${self.public_ip} -i ${self.private_ip} -f pocservers"
    interpreter = ["/bin/bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "bash ../../ssh_conf.sh -a d -i ${self.private_ip} -f pocservers"
    interpreter = ["/bin/bash", "-c"]
  }
}

output "all_instances" {
  value = {
    for _, v in alicloud_instance.pocservers : v.host_name => v.public_ip
  }
}
