output "all_instances" {
  value = {
    for _, v in alicloud_instance.instance : v.host_name => {"public": v.public_ip, "private": v.private_ip}
  }
}
