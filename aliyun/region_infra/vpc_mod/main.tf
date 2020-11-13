locals {
  zone_ids = data.alicloud_zones.zones.ids
  zone_id2ind = {
    for i in range(length(local.zone_ids)) : local.zone_ids[i] => (i + 1)
  }
}

terraform {
  required_providers {
    alicloud = "1.87.0"
  }
}

data "alicloud_zones" "zones" {
}

resource "alicloud_vpc" "playground" {
  name       = "playground"
  cidr_block = "172.16.0.0/16"
}

resource "alicloud_vswitch" "playground_switches" {
  vpc_id = alicloud_vpc.playground.id

  for_each = local.zone_id2ind

  availability_zone = each.key
  cidr_block        = "172.16.${each.value}.0/24"
}

resource "alicloud_security_group" "default_group" {
  vpc_id              = alicloud_vpc.playground.id
  name                = "default_group"
  security_group_type = "normal"
  inner_access_policy = "Accept"
}

resource "alicloud_security_group_rule" "allow_all" {
  security_group_id = alicloud_security_group.default_group.id
  type              = "ingress"
  ip_protocol       = "all"
  port_range        = "1/65535"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  cidr_ip           = "0.0.0.0/0"
}
