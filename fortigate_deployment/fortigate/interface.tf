resource "alicloud_network_interface" "PrimaryFortiGateInterface1" {
depends_on = [time_sleep.wait_45_seconds_after_create_internal_a_vswitch]
//wait for vswitch to cool down, see issues when wait 30 seconds, so changed to 45seonds
 count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : var.number_of_fortigate
  network_interface_name = "createdByTerraform"

  vswitch_id      = var.number_of_zone==1 ? alicloud_vswitch.internal_a[0].id : alicloud_vswitch.internal_a[count.index].id
  security_groups = module.vswitch.sg-id

private_ip=local.cidr_block_ip["internal"][count.index]
}

resource "alicloud_network_interface" "PrimaryFortiGateInterface2" {
  depends_on=[alicloud_network_interface.PrimaryFortiGateInterface1]
 count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : var.number_of_fortigate
  network_interface_name = "createdByTerraform"
  vswitch_id      = var.number_of_zone==1 ? alicloud_vswitch.ha_a[0].id : alicloud_vswitch.ha_a[count.index].id
  security_groups = module.vswitch.sg-id
  private_ip=local.cidr_block_ip["ha"][count.index]
}

resource "alicloud_network_interface" "PrimaryFortiGateInterface3" {
  depends_on=[alicloud_network_interface.PrimaryFortiGateInterface2]
 count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : var.number_of_fortigate
  network_interface_name = "createdByTerraform"
  vswitch_id      = var.number_of_zone==1 ? alicloud_vswitch.mgmt_a[0].id : alicloud_vswitch.mgmt_a[count.index].id
  security_groups = module.vswitch.sg-id
  private_ip=local.cidr_block_ip["mgmt"][count.index]
}

resource "alicloud_network_interface_attachment" "PrimaryFortigateattachment1" {
 count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : var.number_of_fortigate
depends_on           = [alicloud_network_interface.PrimaryFortiGateInterface1]
  instance_id          = alicloud_instance.PrimaryFortigate[count.index].id
  network_interface_id = alicloud_network_interface.PrimaryFortiGateInterface1[count.index].id
}

resource "alicloud_network_interface_attachment" "PrimaryFortigateattachment2" {
 count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : var.number_of_fortigate
  depends_on           = [alicloud_network_interface_attachment.PrimaryFortigateattachment1]
  instance_id          = alicloud_instance.PrimaryFortigate[count.index].id
  network_interface_id = alicloud_network_interface.PrimaryFortiGateInterface2[count.index].id
}

resource "alicloud_network_interface_attachment" "PrimaryFortigateattachment3" {
 count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : var.number_of_fortigate
  depends_on           = [alicloud_network_interface_attachment.PrimaryFortigateattachment2]
  instance_id          = alicloud_instance.PrimaryFortigate[count.index].id
  network_interface_id = alicloud_network_interface.PrimaryFortiGateInterface3[count.index].id
}
