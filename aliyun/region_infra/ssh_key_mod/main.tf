variable "public_key_file_name" {
  type = string
}

variable "key_name" {
  type = string
}

terraform {
  required_providers {
    alicloud = "1.87.0"
  }
}

resource "alicloud_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = file("~/.ssh/private/${var.public_key_file_name}")
}

output "key_name" {
  value = alicloud_key_pair.key_pair.key_name
}
