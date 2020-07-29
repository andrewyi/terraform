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
    "ubuntu18.04" : data.alicloud_images.ubuntu_18_04.ids[0],
    "centos7.8" : data.alicloud_images.centos_7_8.ids[0],
  }

  itype_map = {
    "gn5i" : data.alicloud_instance_types.gn5i.ids[0],
    "gn6i" : data.alicloud_instance_types.gn6i.ids[0],
    "c6e" : data.alicloud_instance_types.c6e.ids[0],
  }
  azone_map = {
    "gn5i" : data.alicloud_instance_types.gn5i.instance_types[0].availability_zones[0],
    "gn6i" : data.alicloud_instance_types.gn6i.instance_types[0].availability_zones[0],
    "c6e" : data.alicloud_instance_types.c6e.instance_types[0].availability_zones[0],
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

data "alicloud_instance_types" "gn5i" {
  // 8.68 /时
  cpu_core_count       = 2
  memory_size          = 8
  instance_type_family = "ecs.gn5i"
  instance_charge_type = "PostPaid"
  network_type         = "Vpc"
}

data "alicloud_instance_types" "gn6i" {
  // 14 /时
  cpu_core_count       = 8
  memory_size          = 31
  instance_type_family = "ecs.gn6i"
  instance_charge_type = "PostPaid"
  network_type         = "Vpc"
}

data "alicloud_instance_types" "c6e" {
  // 0.821 /时
  cpu_core_count       = 4
  memory_size          = 8
  instance_type_family = "ecs.c6e"
  instance_charge_type = "PostPaid"
  network_type         = "Vpc"
}

resource "alicloud_instance" "instance" {
  security_groups            = [alicloud_security_group.default_sec_group.id]
  internet_charge_type       = "PayByTraffic"
  internet_max_bandwidth_out = 100
  instance_charge_type       = "PostPaid"
  key_name                   = local.ssh_key

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
  system_disk_category       = each.value["disk_category"]
  system_disk_size           = each.value["disk_size"]
}
