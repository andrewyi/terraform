ssh_key_name = "andrew_key_for_bid"

instances = {
  "shenzhen" : [
    {
      "name" : "master01",
      "os" : "ubuntu",
      "instance_type" : "compute"
    },
    {
      "name" : "shenzhencluster01",
      "os" : "ubuntu",
      "instance_type" : "compute"
    },
    {
      "name" : "shenzhenclient01",
      "os" : "ubuntu",
      "instance_type" : "compute"
    }
  ],
  "shanghai" : [
    {
      "name" : "shanghaicluster01",
      "os" : "ubuntu",
      "instance_type" : "compute"
    },
    {
      "name" : "shanghaicluster02",
      "os" : "ubuntu",
      "instance_type" : "compute"
    },
    {
      "name" : "shanghaiclient01",
      "os" : "ubuntu",
      "instance_type" : "compute"
    }
  ],
  "beijing" : [
    {
      "name" : "beijingcluster01",
      "os" : "ubuntu",
      "instance_type" : "compute"
    },
    {
      "name" : "beijingcluster02",
      "os" : "ubuntu",
      "instance_type" : "compute"
    },
    {
      "name" : "beijingclient01",
      "os" : "ubuntu",
      "instance_type" : "compute"
    }
  ]
}

