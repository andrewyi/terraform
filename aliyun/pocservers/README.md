# terraform

### terraform.tfvars 参数说明

instance: 
    一个对象(map)，其中的key为

    hostname // 将作为ssh登录名称

    os // 安装的操作系统名称
        ubuntu_18_04
        centos_7_06

    instance_type: // 注意部分实例对磁盘要求限制
        // 注意在terraform中只需要填写型号 "-" 前面的部分（后面通过cpu和ram大小来区分）
        ecs.t6-c1m2 // 2core + 4gram 限制硬盘必须为: >= 高效云盘
        ecs.hfc7 // 4core +8gram 限制硬盘必须为: >= ESSD云盘

    disk_category: // https://www.alibabacloud.com/help/zh/doc-detail/25691.htm
        cloud               普通云盘
        cloud_efficiency    高效云盘
        cloud_ssd           SSD云盘
        cloud_essd          ESSD云盘 // 最高端、性能最好
