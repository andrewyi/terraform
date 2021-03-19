terraform {
  required_providers {
    baiducloud = {
      source = "baidubce/baiducloud"
      version = "1.11.0"
    }
  }
  required_version = "= 0.14.8"
}

provider "baiducloud" {
  region = "gz" // 广州
}

/*
data "baiducloud_zones" "all_zones" {
  output_file = "all_zones.txt"
}

data "baiducloud_images" "centos_images" {
  output_file = "centos_images.txt"

  image_type = "System"
  os_name = "CentOS"
  name_regex = "^7.9 x86_64" // 6.5, 6.8, 7.1-7.9 8.0-8.2
}
*/

data "baiducloud_instances" "created" {
}

output "created" {
  value = {
    for _, v in data.baiducloud_instances.created.instances: v.name => {"public_ip": v.public_ip, "private_ip": v.internal_ip}
  }
}
