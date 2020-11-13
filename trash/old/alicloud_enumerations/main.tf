variable "dest_region" {
  type = string
}

locals {
  region = var.dest_region
}

terraform {
  required_providers {
    alicloud = "1.89.0"
  }
}

provider "alicloud" {
  region = local.region
}

data "alicloud_regions" "all_regions" {
  output_file = "all_regions.txt"
}

data "alicloud_zones" "all_zones" {
  output_file = "all_zones.txt"
}

data "alicloud_images" "mainstream_linux" {
  owners      = "system"
  // most_recent = true
  output_file = "centos_images.txt"

  name_regex  = "centos_7"
}

data "alicloud_instance_types" "gn5i" {
  // 8.68 /时
  cpu_core_count       = 2
  memory_size          = 8
  instance_type_family = "ecs.gn5i"
  instance_charge_type = "PostPaid"
  network_type         = "Vpc"

  output_file          = "gn5i_instance_types.txt"
}

output "instance_type_gn5i" {
  value = data.alicloud_instance_types.gn5i
}
