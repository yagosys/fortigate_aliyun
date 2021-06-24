data "alicloud_regions" "current_region_ds" {
  current = true
}

data "alicloud_zones" "default" {
}


data "alicloud_eips" "eips_ds" {
}

resource "random_string" "psk" {
  length           = 16
  special          = true
  override_special = ""
}


resource "random_string" "random_name_post" {
  length           = 4
  special          = true
  override_special = ""
  min_lower        = 4
}


//Security Group for fortigate instances
resource "alicloud_security_group" "SecGroup" {
  name        = "${var.cluster_name}-SecGroup-${random_string.random_name_post.result}"
  description = "New security group"
  vpc_id      = alicloud_vpc.vpc.id
}

//Allow All Ingress for Firewall
resource "alicloud_security_group_rule" "allow_all_tcp_ingress" {
  type              = "ingress"
  ip_protocol       = "all"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "1/-1"
  priority          = 1
  security_group_id = alicloud_security_group.SecGroup.id
  cidr_ip           = "0.0.0.0/0"
}


resource "alicloud_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  name       = "${var.cluster_name}-${random_string.random_name_post.result}"
}

variable "custom_route_table_count" {
  type    = number
  default = 1

}
//default for primary fortigate, default route for internal network is torwars primary fortigate secondary inteface (primaryFortigateInterface1)
resource "alicloud_route_table" "custom_route_tables" {
  count       = 1
  vpc_id      = alicloud_vpc.vpc.id
  name        = "${var.cluster_name}-FortiGateEgress-${random_string.random_name_post.result}-${count.index}"
  description = "FortiGate Egress route tables, created with terraform."
}





resource "alicloud_route_entry" "custom_route_table_egress" {
  depends_on            = [alicloud_network_interface.PrimaryFortiGateInterface1]
  count                 = 1
  route_table_id        = alicloud_route_table.custom_route_tables[count.index].id
  destination_cidrblock = var.default_egress_route //Default is 0.0.0.0/0
  nexthop_type          = "NetworkInterface"
  name                  = alicloud_network_interface.PrimaryFortiGateInterface1.id
  nexthop_id            = alicloud_network_interface.PrimaryFortiGateInterface1.id
}
resource "alicloud_route_table_attachment" "custom_route_table_attachment_private" {
  count          = 1
  vswitch_id     = alicloud_vswitch.internal_a.id
  route_table_id = alicloud_route_table.custom_route_tables[count.index].id
}



resource "alicloud_vswitch" "external_a" {
  name              = "external_a"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_a_cidr_1
  availability_zone = var.fgt1_availability_zone
}

resource "alicloud_vswitch" "internal_a" {
  name              = "internal_a"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_a_cidr_2
  availability_zone = var.fgt1_availability_zone
}

resource "alicloud_vswitch" "ha_ap_unicast_a" {
  name              = "ha_ap_unicast_a"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_a_cidr_3
  availability_zone = var.fgt1_availability_zone
}

resource "alicloud_vswitch" "mgmt_a" {
  name              = "mgmt_a"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_a_cidr_4
  availability_zone = var.fgt1_availability_zone
}

resource "alicloud_vswitch" "external_b" {
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_b_cidr_1
  availability_zone = var.fgt2_availability_zone
}

resource "alicloud_vswitch" "internal_b" {
  name              = "internal_b"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_b_cidr_2
  availability_zone = var.fgt2_availability_zone
}

resource "alicloud_vswitch" "ha_ap_unicast_b" {
  name              = "ha_ap_unicast_b"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_b_cidr_3
  availability_zone = var.fgt2_availability_zone
}

resource "alicloud_vswitch" "mgmt_b" {
  name              = "mgmt_b"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_b_cidr_4
  availability_zone = var.fgt2_availability_zone
}

resource "time_sleep" "wait_120_seconds" {
  depends_on = [alicloud_vswitch.internal_a]

  create_duration = "120s"
}


resource "alicloud_network_interface" "PrimaryFortiGateInterface1" {
 // depends_on      = [alicloud_vswitch.internal_a]
  depends_on = [time_sleep.wait_120_seconds]
  name            = "${var.cluster_name}-Primary-Internal-ENI-${random_string.random_name_post.result}"
  vswitch_id      = alicloud_vswitch.internal_a.id
  security_groups = ["${alicloud_security_group.SecGroup.id}"]
  private_ip      = "10.0.12.11"
}

resource "alicloud_network_interface" "PrimaryFortiGateInterface2" {
  depends_on      = [alicloud_network_interface.PrimaryFortiGateInterface1]
  name            = "${var.cluster_name}-Primary-HA-ENI-${random_string.random_name_post.result}"
  vswitch_id      = alicloud_vswitch.ha_ap_unicast_a.id
  security_groups = ["${alicloud_security_group.SecGroup.id}"]
  private_ip      = "10.0.13.11"
}
resource "alicloud_network_interface" "PrimaryFortiGateInterface3" {
  depends_on      = [alicloud_network_interface.PrimaryFortiGateInterface2]
  name            = "${var.cluster_name}-Primary-MGMT-ENI-${random_string.random_name_post.result}"
  vswitch_id      = alicloud_vswitch.mgmt_a.id
  security_groups = ["${alicloud_security_group.SecGroup.id}"]
  private_ip      = "10.0.14.11"
}

resource "alicloud_eip" "FgaMgmtEip" {
  name                 = "EIP1"
  bandwidth            = "5"
  internet_charge_type = "PayByBandwidth"
}

resource "alicloud_eip" "FgbMgmtEip" {
  name                 = "EIP2"
  bandwidth            = "5"
  internet_charge_type = "PayByBandwidth"
}

resource "alicloud_eip_association" "eip_asso_fga_mgmt" {
  allocation_id      = alicloud_eip.FgaMgmtEip.id
  instance_type      = "NetworkInterface"
  instance_id        = alicloud_network_interface.PrimaryFortiGateInterface3.id
  private_ip_address = "10.0.14.11"
}

resource "alicloud_eip_association" "eip_asso_fgb_mgmt" {
  allocation_id      = alicloud_eip.FgbMgmtEip.id
  instance_type      = "NetworkInterface"
  instance_id        = alicloud_network_interface.SecondaryFortiGateInterface3.id
  private_ip_address = "10.0.24.12"
}


resource "alicloud_eip" "PublicInternetIp" {
  name                 = "EIP3"
  bandwidth            = "5"
  internet_charge_type = "PayByBandwidth"
}


resource "alicloud_eip_association" "eip_asso_fga_port1" {
  allocation_id = alicloud_eip.PublicInternetIp.id
  instance_id   = alicloud_instance.PrimaryFortigate.id
}


resource "alicloud_instance" "PrimaryFortigate" {
  depends_on = [alicloud_network_interface.PrimaryFortiGateInterface3]
  // availability_zone = "${data.alicloud_zones.default.zones.0.id}"
  availability_zone = var.fgt1_availability_zone
  security_groups   = alicloud_security_group.SecGroup.*.id
  image_id          = var.instance_ami
  user_data         = data.template_file.setupPrimary.rendered
  instance_type     = data.alicloud_instance_types.types_ds.instance_type_family
  //  user_data = "${data.template_file.license.rendered}"
  system_disk_category = "cloud_efficiency"
  instance_name        = "${var.cluster_name}-Primary-FortiGate-${random_string.random_name_post.result}"
  vswitch_id           = alicloud_vswitch.external_a.id
  private_ip           = var.primary_fortigate_private_ip
  // dry_run = true
  role_name = "Fortigate-HA-New"
  tags = {
    Name = "FGT1"
  }
  //Logging Disk
  data_disks {
    size                 = 30
    category             = "cloud_ssd"
    delete_with_instance = true
  }
}

//bind secondary ENI to primary instances
resource "alicloud_network_interface_attachment" "PrimaryFortigateattachment1" {
  instance_id          = alicloud_instance.PrimaryFortigate.id
  network_interface_id = alicloud_network_interface.PrimaryFortiGateInterface1.id
}

resource "alicloud_network_interface_attachment" "PrimaryFortigateattachment2" {
  depends_on           = [alicloud_network_interface_attachment.PrimaryFortigateattachment1]
  instance_id          = alicloud_instance.PrimaryFortigate.id
  network_interface_id = alicloud_network_interface.PrimaryFortiGateInterface2.id
}

resource "alicloud_network_interface_attachment" "PrimaryFortigateattachment3" {
  depends_on           = [alicloud_network_interface_attachment.PrimaryFortigateattachment2]
  instance_id          = alicloud_instance.PrimaryFortigate.id
  network_interface_id = alicloud_network_interface.PrimaryFortiGateInterface3.id
}


//for SecondaryForitgate


//secondary ENI for secondaryfortigate and bind to switch in zone b
resource "alicloud_network_interface" "SecondaryFortiGateInterface1" {
  depends_on      = [alicloud_vswitch.internal_b]
  name            = "${var.cluster_name}-Secondary-Internal-ENI-${random_string.random_name_post.result}"
  vswitch_id      = alicloud_vswitch.internal_b.id
  security_groups = ["${alicloud_security_group.SecGroup.id}"]
  private_ip      = "10.0.22.12"
}
//Third ENI for secondaryFortigate
resource "alicloud_network_interface" "SecondaryFortiGateInterface2" {
  depends_on      = [alicloud_network_interface.SecondaryFortiGateInterface1]
  name            = "${var.cluster_name}-Secondary-HA-ENI-${random_string.random_name_post.result}"
  vswitch_id      = alicloud_vswitch.ha_ap_unicast_b.id
  security_groups = ["${alicloud_security_group.SecGroup.id}"]
  private_ip      = "10.0.23.12"
}
//Forth ENI for secondaryFortigate
resource "alicloud_network_interface" "SecondaryFortiGateInterface3" {
  depends_on      = [alicloud_network_interface.SecondaryFortiGateInterface2]
  name            = "${var.cluster_name}-Secondary-MGMT-ENI-${random_string.random_name_post.result}"
  vswitch_id      = alicloud_vswitch.mgmt_b.id
  security_groups = ["${alicloud_security_group.SecGroup.id}"]
  private_ip      = "10.0.24.12"
}


resource "alicloud_instance" "SecondaryFortigate" {
  depends_on = [alicloud_network_interface.SecondaryFortiGateInterface3]
  // availability_zone = "${data.alicloud_zones.default.zones.1.id}"
  availability_zone = var.fgt2_availability_zone
  security_groups   = alicloud_security_group.SecGroup.*.id
  image_id          = var.instance_ami
  user_data         = data.template_file.setupSecondary.rendered
  //user_data = "${base64encode(data.template_file.userdata_sec_lic.rendered)}"
  instance_type = data.alicloud_instance_types.types_ds.instance_type_family
  //instance_type = "ecs.sn1ne.large"
  system_disk_category = "cloud_efficiency"
  instance_name        = "${var.cluster_name}-Secondary-FortiGate-${random_string.random_name_post.result}"
  vswitch_id           = alicloud_vswitch.external_b.id
  private_ip           = var.secondary_fortigate_private_ip
  role_name            = "Fortigate-HA-New"
  //Logging Disk
  //dry_run = true
  tags = {
    Name = "FGT2"
  }
  data_disks {
    size                 = 30
    category             = "cloud_ssd"
    delete_with_instance = true
  }
}


resource "alicloud_instance" "web-a" {
  depends_on      = [alicloud_vswitch.internal_a]
  image_id        = "ubuntu_18_04_x64_20G_alibase_20200521.vhd"
  security_groups = alicloud_security_group.SecGroup.*.id
  // instance_type        = "ecs.n1.tiny"
  instance_type        = "ecs.t5-lc2m1.nano"
  system_disk_category = "cloud_efficiency"
  instance_name        = "web-a"
  vswitch_id           = alicloud_vswitch.internal_a.id
  private_ip           = "10.0.12.109"
  password             = "Welcome.123"
  host_name            = "web-a"

}


//bind secondary ENI to secondary instances
resource "alicloud_network_interface_attachment" "SecondaryFortigateattachment1" {
  instance_id          = alicloud_instance.SecondaryFortigate.id
  network_interface_id = alicloud_network_interface.SecondaryFortiGateInterface1.id
}

resource "alicloud_network_interface_attachment" "SecondaryFortigateattachment2" {
  depends_on           = [alicloud_network_interface_attachment.SecondaryFortigateattachment1]
  instance_id          = alicloud_instance.SecondaryFortigate.id
  network_interface_id = alicloud_network_interface.SecondaryFortiGateInterface2.id
}

resource "alicloud_network_interface_attachment" "SecondaryFortigateattachment3" {
  depends_on           = [alicloud_network_interface_attachment.SecondaryFortigateattachment2]
  instance_id          = alicloud_instance.SecondaryFortigate.id
  network_interface_id = alicloud_network_interface.SecondaryFortiGateInterface3.id
}




//for primaryFortigate
output "PrimaryFortigatePublicIP" {
  value = alicloud_instance.PrimaryFortigate.public_ip
}

output "PrimaryFortigate_MGMT_EIP" {
  value = alicloud_eip.FgaMgmtEip.ip_address
}

output "PrimaryFortigateAvailability_zone" {
  value = alicloud_instance.PrimaryFortigate.availability_zone
}

output "PrimaryFortigatePrivateIP" {
  value = alicloud_instance.PrimaryFortigate.private_ip
}

output "PrimaryFortigateID" {
  value = alicloud_instance.PrimaryFortigate.id
}

//for secondaryFortigate
output "SecondaryFortigatePublicIP" {
  value = alicloud_instance.SecondaryFortigate.public_ip
}

output "SecondaryFortigate_MGMT_EIP" {
  value = alicloud_eip.FgbMgmtEip.ip_address
}

output "SecondaryFortigateAvailability_zone" {
  value = alicloud_instance.SecondaryFortigate.availability_zone
}


output "SecondaryFortigatePrivateIP" {
  value = alicloud_instance.SecondaryFortigate.private_ip
}

output "SecondaryFortigateID" {
  value = alicloud_instance.SecondaryFortigate.id
}

output "ActiveFortigateEIP3" {
  value= alicloud_eip.PublicInternetIp.ip_address
}

resource "alicloud_ram_role" "role" {
  name     = "Fortigate-HA-New"
  document = <<EOF
    {
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Effect": "Allow",
          "Principal": {
            "Service": [
              "ecs.aliyuncs.com"
            ]
          }
        }
      ],
      "Version": "1"
    }
EOF

  description = "this is a role test."
  force       = true
}

//
resource "alicloud_ram_policy" "policy" {
  name     = "Fortigate-HA-New-rule"
  document = <<EOF
    {
      "Statement": [
        {
          "Action": [
                "vpc:*",
		"vpc:*EipAddress*",
		"vpc:UntagResources",
		"vpc:TagResources",
		"vpc:*VSwitch*",
		"ecs:*",
		"ecs:DescribeInstances",
		"vpc:DescribeVpcs",
		"vpc:DescribeVSwitches",
		"vpc:*Eip*",
		"vpc:*HighDefinitionMonitor*",
                "vpc:*HaVip*",
                "vpc:*RouteTable*",
                "vpc:*VRouter*",
                "vpc:*RouteEntry*",
                "vpc:*VSwitch*",
                "vpc:*Vpc*",
                "vpc:*Cen*",
                "vpc:*Tag*",
                "vpc:*NetworkAcl*",
		"ecs:*Instance*"

          ],
          "Effect": "Allow",
          "Resource": [
            "*"
          ]
        },
        {
                "Action": [
                "ecs:*"

            ],
            "Resource": "*",
            "Effect": "Allow"
        }
      ],
        "Version": "1"
    }
EOF

  description = "this is a policy test"
  force       = true
}
//


resource "alicloud_ram_role_policy_attachment" "attach" {
  policy_name = alicloud_ram_policy.policy.name
  role_name   = alicloud_ram_role.role.name
  policy_type = alicloud_ram_policy.policy.type
}

