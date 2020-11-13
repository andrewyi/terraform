variable "required_nodes" {
  type = map(object({
    name = string
    role = string
  }))
}

locals {
  region = "cn-shenzhen"

  azone_ids = data.alicloud_zones.all_zones.ids
  azone_id2ind = {
    for i in range(length(local.azone_ids)) : local.azone_ids[i] => (i + 1)
  }
  vswitch_z2id = {
    for s in alicloud_vswitch.ephemeral_k8s_vpc_switches :
    s.availability_zone => s.id
  }

  ssh_key                = data.alicloud_key_pairs.common_key.ids[0]
  ubuntu_18_04_x64_image = data.alicloud_images.ubuntu_18_04.ids[0]
  cheapest_instance_type = data.alicloud_instance_types.cheap_2c4g.ids[0]
  instance_azone         = data.alicloud_instance_types.cheap_2c4g.instance_types[0].availability_zones[0]
}

terraform {
  required_providers {
    alicloud = "1.87.0"
  }
}

provider "alicloud" {
  region = local.region
}

data "alicloud_zones" "all_zones" {
}

data "alicloud_key_pairs" "common_key" {
  name_regex = "andrew_id_rsa"
}

data "alicloud_images" "ubuntu_18_04" {
  owners      = "system"
  name_regex  = "^ubuntu_18_04_x64"
  most_recent = true
}

data "alicloud_instance_types" "cheap_2c4g" {
  # ￥ 0.236 /时
  cpu_core_count       = 2
  memory_size          = 4
  instance_type_family = "ecs.t6"
  instance_charge_type = "PostPaid"
  network_type         = "Vpc"
}

resource "alicloud_vpc" "ephemeral_k8s_vpc" {
  name       = "ephemeral_k8s_vpc"
  cidr_block = "172.16.0.0/16"
}

resource "alicloud_vswitch" "ephemeral_k8s_vpc_switches" {
  vpc_id = alicloud_vpc.ephemeral_k8s_vpc.id

  for_each = local.azone_id2ind

  availability_zone = each.key
  cidr_block        = "172.16.${each.value}.0/24"
}

resource "alicloud_security_group" "default_sec_group" {
  name                = "default_test_group"
  security_group_type = "normal"
  vpc_id              = alicloud_vpc.ephemeral_k8s_vpc.id
}

resource "alicloud_security_group_rule" "allow_all_tcp" {
  type              = "ingress"
  ip_protocol       = "tcp"
  port_range        = "1/65535"
  security_group_id = alicloud_security_group.default_sec_group.id
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_instance" "instance" {
  image_id        = local.ubuntu_18_04_x64_image
  instance_type   = local.cheapest_instance_type
  security_groups = [alicloud_security_group.default_sec_group.id]
  # availability_zone = local.instance_azone # determined by vswitch
  internet_charge_type       = "PayByTraffic"
  internet_max_bandwidth_out = 100
  vswitch_id                 = local.vswitch_z2id[local.instance_azone]
  instance_charge_type       = "PostPaid"
  key_name                   = local.ssh_key

  for_each = var.required_nodes

  host_name     = each.value["name"]
  instance_name = each.value["name"]
}

output "all_instances" {
  value = {
    for _, v in alicloud_instance.instance : v.host_name => v.public_ip
  }
}
