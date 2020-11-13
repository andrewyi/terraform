terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
      version = "1.46.4"
    }
  }
  required_version = ">= 0.13"
}

provider "tencentcloud" {
  region = "ap-guangzhou"
}

/*
data "tencentcloud_regions" "all_regions" {
  output_file = "all_regions.txt"
}

data "tencentcloud_regions" "all_zones" {
  output_file = "all_zones.txt"
}
*/

data "tencentcloud_images" "mainstream_linux" {
  image_type = ["PUBLIC_IMAGE"]
  // most_recent = true
  result_output_file = "centos_images.txt"

  // image_name_regex  = "centos"
}

data "tencentcloud_instance_types" "instances" {
  cpu_core_count       = 2
  memory_size          = 4
  filter               {
    name = "instance-family"
    values = ["S5"]
  }
  result_output_file   = "instances.txt"
}

/*
output "instance_type_gn5i" {
  value = data.alicloud_instance_types.gn5i
}
*/
