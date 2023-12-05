output "PrimaryFortigatePublicIP" {
  value = alicloud_instance.PrimaryFortigate.*.public_ip
}

output "PrimaryFortigateID" {
  value =  var.fortigate["internet_max_bandwidth_out"] !="0" ? alicloud_instance.PrimaryFortigate.*.id : null 
}

output "MgmtFortigateIP" {
 value = var.mgmt_eip==1 ? alicloud_eip.MgmtEip.*.ip_address: null
}
