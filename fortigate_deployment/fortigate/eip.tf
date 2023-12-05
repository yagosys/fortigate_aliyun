resource "alicloud_eip" "MgmtEip" {
 count= var.mgmt_eip==1 ? var.number_of_fortigate : 0
  name                 = "EIP-${count.index}"
  bandwidth            = "1"
  internet_charge_type = "PayByTraffic"
}

resource "alicloud_eip_association" "eip_asso_mgmt" {
 count= var.mgmt_eip==1 ? var.number_of_fortigate : 0
depends_on = [time_sleep.wait_60_seconds_after_create_primary_fortigate_interface3]
//possible attach fail, watch out here
  allocation_id      = alicloud_eip.MgmtEip[count.index].id
  instance_type      = "NetworkInterface"
  instance_id        = alicloud_network_interface.PrimaryFortiGateInterface3[count.index].id
}

resource "alicloud_eip" "PublicInternetIp" {
  count = var.eip==1 ? 1 : 0
  name                 = "EIP3"
  bandwidth            = "5"
  internet_charge_type = "PayByTraffic"
}

resource "alicloud_eip_association" "eip_asso_fga_port1" {
depends_on=[time_sleep.wait_180_seconds_after_create_Primary_fortigate[0]]
  count = var.eip==1 ? 1 : 0
  allocation_id = alicloud_eip.PublicInternetIp[count.index].id
  instance_id   = alicloud_instance.PrimaryFortigate[count.index].id
}

output "ActiveFortigateEIP3" {
  value = var.eip==1 ? alicloud_eip.PublicInternetIp.*.ip_address : null
}
