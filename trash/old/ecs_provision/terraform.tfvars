// for a list of available zones, refer to alicloud enumerations
dest_region = "cn-shenzhen"

// note ssh key is bound to a region, if you have no key defined, commment 
// this line and use server_password to set server login credential
ssh_key_name = "andrew_id_rsa"

// server_password = "330pAsSwOrD578"

required_nodes = [
  {
    "name" : "pocmaster",
    "role" : "master"
  }
]

