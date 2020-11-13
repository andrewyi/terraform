variable "vpc_id" {
  type = string
}

variable "ssh_key_id" {
  type = string
}

variable "sec_group_id" {
  type = string
}

terraform {
  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = "1.46.4"
    }
  }
  required_version = ">= 0.13"
}

provider "tencentcloud" {
  region = "ap-guangzhou"
}

locals {
  vpc_id        = data.tencentcloud_vpc_instances.default.instance_list[0].vpc_id
  sec_group_ids = data.tencentcloud_security_groups.all_open_group.security_groups.*.security_group_id
  ins_type      = data.tencentcloud_instance_types.s5_small2.instance_types[0].instance_type
  a_zone        = data.tencentcloud_instance_types.s5_small2.instance_types[0].availability_zone
  subnet_id     = data.tencentcloud_vpc_subnets.subnets.instance_list[0].subnet_id
  image_id      = data.tencentcloud_images.centos_7_06.images[0].image_id
  ssh_key_name  = data.tencentcloud_key_pairs.key.key_pair_list[0].key_id
}

data "tencentcloud_key_pairs" "key" {
  key_id = var.ssh_key_id
}

/*
data "tencentcloud_images" "ubuntu_18_04" {
  image_type       = ["PUBLIC_IMAGE"]
  image_name_regex = "Ubuntu Server 18.04.1 LTS 64bit"
}
*/

data "tencentcloud_images" "centos_7_06" {
  image_type       = ["PUBLIC_IMAGE"]
  image_name_regex = "CentOS 7.6 64bit"
}

data "tencentcloud_vpc_instances" "default" {
  vpc_id = var.vpc_id
}

data "tencentcloud_security_groups" "all_open_group" {
  security_group_id = var.sec_group_id
}

data "tencentcloud_vpc_subnets" "subnets" {
  vpc_id            = var.vpc_id
  availability_zone = local.a_zone
}

data "tencentcloud_instance_types" "s5_small2" {
  cpu_core_count = 1
  memory_size    = 2
  filter {
    name   = "instance-family"
    values = ["S5"]
  }
}

/*
data "tencentcloud_instance_types" "s5_medium4" {
  cpu_core_count       = 2
  memory_size          = 4
  filter               {
    name = "instance-family"
    values = ["S5"]
  }
}
*/

resource "tencentcloud_instance" "myneighbour" {
  instance_name = "myneighbour"
  hostname      = "myneighbour"

  instance_charge_type = "POSTPAID_BY_HOUR"

  availability_zone = local.a_zone
  image_id          = local.image_id
  instance_type     = local.ins_type
  system_disk_type  = "CLOUD_SSD"
  system_disk_size  = 50

  key_name = local.ssh_key_name


  vpc_id    = local.vpc_id
  subnet_id = local.subnet_id

  allocate_public_ip         = true
  internet_charge_type       = "TRAFFIC_POSTPAID_BY_HOUR"
  internet_max_bandwidth_out = 100
  security_groups            = local.sec_group_ids

  provisioner "local-exec" {
    command     = "bash ../../ssh_conf.sh -a i -t ${self.hostname} -e ${self.public_ip} -i ${self.private_ip} -f myneighbour"
    interpreter = ["/bin/bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "bash ../../ssh_conf.sh -a d -i ${self.private_ip} -f myneighbour"
    interpreter = ["/bin/bash", "-c"]
  }
}

/*
output "all_instances" {
  value = tencentcloud_instance.myneighbour
}
*/

output "all_instances" {
  value = {
    "hostname": tencentcloud_instance.myneighbour.hostname,
    "publi_ip": tencentcloud_instance.myneighbour.public_ip,
    "private_ip": tencentcloud_instance.myneighbour.private_ip
  }
}
