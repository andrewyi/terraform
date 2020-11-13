ssh_key_name = "andrew_id_rsa"

required_nodes = [
  {
    "name" : "socketserver",
    "os" : "ubuntu18.04",
    "instance_type" : "t6",
    "disk_category" : "cloud_efficiency",
    "disk_size" : 40,
  },
  {
    "name" : "socketclient",
    "os" : "ubuntu18.04",
    "instance_type" : "t6",
    "disk_category" : "cloud_efficiency",
    "disk_size" : 40,
  }
]
