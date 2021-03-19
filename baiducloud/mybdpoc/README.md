# terraform

### baiducloud differs in
* no auto public ip allocation
    * must allocat eip and bind
* no instance type selection (not explained)
    * use "N3"

### and more
* fail to list module created instances info
    * so use antoher terraform apply to get created instances
