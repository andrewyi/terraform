# 参数说明

ssh_key_name:
    andrew_id_rsa // 个人预先配置好的密钥对

required_nodes: 
    一个数组，其中的对象属性需要满足以下要求

    name:
        ${arbitary_name_str}

    os:
        ubuntu18.04
        // centos7.8 // deprecated, not compatible with our nvidia docker installation script

    instance_type: // 注意部分实例对磁盘要求限制
        gn5i // 2c8g+1p4    限制硬盘必须为: 高效云盘/SSD云盘
        gn6i // 8c31g+1t4   限制硬盘必须为: 高效云盘/SSD云盘/ESSD云盘
        c6e  // 4c8g        限制硬盘必须为: ESSD云盘
        t6   // 2c4g        限制硬盘必须为: 高效云盘/SSD云盘

    disk_category: // https://www.alibabacloud.com/help/zh/doc-detail/25691.htm
        cloud               普通云盘
        cloud_efficiency    高效云盘
        cloud_ssd           SSD云盘
        cloud_essd          ESSD盘 // 最高端、性能最好

    disk_size:
        20 - 500 G
