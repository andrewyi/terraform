variable "ssh_key_name" {
  type    = string
  default = null
}

variable "required_nodes" {
  type = list(object({
    name          = string
    os            = string
    instance_type = string
    disk_category = string
    disk_size     = number
  }))
}
