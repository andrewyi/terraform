# terraform

### terraform.tfvars 参数说明

instance: 
    一个对象(map)，其中的key为

    instance_type: // 注意部分实例对磁盘要求限制
        t5-lc2m1 // 1core + 0.5gram 限制硬盘必须为: 高效云盘/SSD云盘

    disk_category: // https://www.alibabacloud.com/help/zh/doc-detail/25691.htm
        cloud               普通云盘
        cloud_efficiency    高效云盘
        cloud_ssd           SSD云盘
        cloud_essd          ESSD盘 // 最高端、性能最好
