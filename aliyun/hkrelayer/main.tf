variable "instance" {
  type = object({
    instance_type = string
    disk_category = string
  })
}

terraform {
  required_providers {
    alicloud = {
      source = "aliyun/alicloud"
      version = "1.103.1"
    }
  }
  required_version = ">= 0.13"
}

provider "alicloud" {
  region = "cn-hongkong"
}

locals {
  vpc_id               = data.alicloud_vpcs.playground.ids[0]
  default_sec_group_id = data.alicloud_security_groups.default_group.ids[0]
  vswitch_zone2id = {
    for s in data.alicloud_vswitches.switches.vswitches : s.zone_id => s.id
  }
  os_image_id = data.alicloud_images.ubuntu_18_04.ids[0]
  ssh_key     = data.alicloud_key_pairs.key.ids[0]

  itype_map = {
    "t5-lc2m1" : data.alicloud_instance_types.t5_lc2m1.ids[0],
  }
  azone_map = {
    "t5-lc2m1" : data.alicloud_instance_types.t5_lc2m1.instance_types[0].availability_zones[0],
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

data "alicloud_instance_types" "t5_lc2m1" {
  // 0.05 /时
  instance_type_family = "ecs.t5"
  cpu_core_count       = 1
  memory_size          = 0.5
  instance_charge_type = "PostPaid"
  network_type         = "Vpc"
}

resource "alicloud_instance" "hkrelayer" {
  instance_charge_type       = "PostPaid"
  internet_charge_type       = "PayByTraffic"
  internet_max_bandwidth_out = 100
  security_groups            = [local.default_sec_group_id]
  key_name                   = local.ssh_key
  image_id                   = local.os_image_id
  system_disk_size           = 40
  host_name                  = "hkrelayer"
  instance_name              = "hkrelayer"

  system_disk_category = var.instance["disk_category"]
  instance_type        = local.itype_map[var.instance["instance_type"]]
  vswitch_id           = local.vswitch_zone2id[
    local.azone_map[var.instance["instance_type"]]]

  provisioner "local-exec" {
    command     = "bash ../ssh_conf.sh -a i -t ${self.host_name} -e ${self.public_ip} -i ${self.private_ip} -f hkrelayer"
    interpreter = ["/bin/bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "bash ../ssh_conf.sh -a d -i ${self.private_ip} -f hkrelayer"
    interpreter = ["/bin/bash", "-c"]
  }
}

output "all_instances" {
  value = {
    "host_name" : alicloud_instance.hkrelayer.host_name,
    "public_ip" : alicloud_instance.hkrelayer.public_ip,
  }
}
