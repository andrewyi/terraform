variable "ssh_key_name" {
  type    = string
  default = null
}

variable "required_nodes" {
  type = list(object({
    name          = string
    os            = string
    instance_type = string
  }))
}

locals {
  zone_ids = data.alicloud_zones.zones.ids
  zone_id2ind = {
    for i in range(length(local.zone_ids)) : local.zone_ids[i] => (i + 1)
  }
  vswitch_zone2id = {
    for s in alicloud_vswitch.ephemeral_k8s_vpc_switches :
    s.availability_zone => s.id
  }

  ssh_key = data.alicloud_key_pairs.key.ids[0]

  os_map = {
    "ubuntu" : data.alicloud_images.ubuntu_18_04.ids[0],
    "centos" : data.alicloud_images.centos_7_8.ids[0],
  }

  // ignore the non-existent error
  l2c4g_type_count = length(data.alicloud_instance_types.l2c4g.ids)
  c4c8gb_type_count = length(data.alicloud_instance_types.c4c8gb.ids)
  c4c8g_type_count = length(data.alicloud_instance_types.c4c8g.ids)
  itype_map = {
    "cheap" : local.l2c4g_type_count != 0 ? data.alicloud_instance_types.l2c4g.ids[0] : null,
    "bcompute" : local.c4c8gb_type_count != 0 ? data.alicloud_instance_types.c4c8gb.ids[0] : null,
    "compute" : local.c4c8g_type_count != 0 ? data.alicloud_instance_types.c4c8g.ids[0] : null,
  }
  azone_map = {
    "cheap" : local.l2c4g_type_count != 0 ? data.alicloud_instance_types.l2c4g.instance_types[0].availability_zones[0] : null,
    "bcompute" : local.c4c8gb_type_count != 0 ? data.alicloud_instance_types.c4c8gb.instance_types[0].availability_zones[0] : null
    "compute" : local.c4c8g_type_count != 0 ? data.alicloud_instance_types.c4c8g.instance_types[0].availability_zones[0] : null
  }
}

terraform {
  required_providers {
    alicloud = "1.80.0"
  }
}

data "alicloud_zones" "zones" {
}

data "alicloud_key_pairs" "key" {
  name_regex = var.ssh_key_name
}

data "alicloud_images" "ubuntu_18_04" {
  owners      = "system"
  name_regex  = "^ubuntu_18_04_x64"
  most_recent = true
}

data "alicloud_images" "centos_7_8" {
  owners      = "system"
  name_regex  = "^centos_7_8_x64"
  most_recent = true
}

resource "alicloud_vpc" "ephemeral_k8s_vpc" {
  name       = "ephemeral_k8s_vpc"
  cidr_block = "172.16.0.0/16"
}

resource "alicloud_vswitch" "ephemeral_k8s_vpc_switches" {
  vpc_id = alicloud_vpc.ephemeral_k8s_vpc.id

  for_each = local.zone_id2ind

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

data "alicloud_instance_types" "l2c4g" {
  // 0.236 /时
  cpu_core_count       = 2
  memory_size          = 4
  instance_type_family = "ecs.t6"
  instance_charge_type = "PostPaid"
  network_type         = "Vpc"
}

data "alicloud_instance_types" "c4c8gb" {
  // 0.821 /时
  cpu_core_count       = 4
  memory_size          = 8
  instance_type_family = "ecs.c6e"
  instance_charge_type = "PostPaid"
  network_type         = "Vpc"
}

data "alicloud_instance_types" "c4c8g" {
  // 0.78 /时
  cpu_core_count       = 4
  memory_size          = 8
  instance_type_family = "ecs.c6"
  instance_charge_type = "PostPaid"
  network_type         = "Vpc"
}

resource "alicloud_instance" "instance" {
  security_groups            = [alicloud_security_group.default_sec_group.id]
  internet_charge_type       = "PayByTraffic"
  internet_max_bandwidth_out = 100
  instance_charge_type       = "PostPaid"
  key_name                   = local.ssh_key
  system_disk_category       = "cloud_essd"

  for_each = {
    for i in range(length(var.required_nodes)) : i => var.required_nodes[i]
  }

  host_name     = each.value["name"]
  instance_name = each.value["name"]
  image_id      = local.os_map[each.value["os"]]
  instance_type = local.itype_map[each.value["instance_type"]]

  // availability_zone is determined by vswitch
  vswitch_id = local.vswitch_zone2id[
    local.azone_map[each.value["instance_type"]]]
}

output "all_instances" {
  value = {
    for _, v in alicloud_instance.instance : v.host_name => v.public_ip
  }
}
