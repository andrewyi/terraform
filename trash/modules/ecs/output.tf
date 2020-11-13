output "all_instances" {
  value = {
    for _, v in alicloud_instance.instance : v.host_name => v.public_ip
  }
}
