variable "ssh_key_id" {
  type    = string
  default = "k-OS2Vya4g"
}

variable "instance_name" {
  type = string
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

data "baiducloud_images" "centos" {
  image_type       = "System"
  os_name          = "CentOS"
  name_regex = "^7.9 x86_64" // 6.5, 6.8, 7.1-7.9, 8.0-8.2
}

resource "baiducloud_instance" "instance" {
  billing = {
    "payment_timing" : "Postpaid"
  }

  cpu_count             = 2
  memory_capacity_in_gb = 4
  instance_type         = "N3"

  image_id             = data.baiducloud_images.centos.images[0].id
  root_disk_size_in_gb = 50
  // root_disk_storage_type = "cloud_hp1" // std1, hp1, cloud_hp1, local, sata, ssd

  keypair_id = var.ssh_key_id
  name       = var.instance_name
}

resource "baiducloud_eip" "instance" {
  // name              = var.instance_name
  bandwidth_in_mbps = 200
  payment_timing    = "Postpaid"
  billing_method    = "ByTraffic"
}

resource "baiducloud_eip_association" "instance" {
  eip           = baiducloud_eip.instance.eip
  instance_type = "BCC"
  instance_id   = baiducloud_instance.instance.id
}

output "instance_info" {
  value = {
    "hostname" : baiducloud_instance.instance.name,
    "public_ip" : baiducloud_instance.instance.public_ip,
    "private_ip" : baiducloud_eip.instance.eip
  }
}
