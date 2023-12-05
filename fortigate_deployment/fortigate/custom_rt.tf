resource "alicloud_route_table" "custom_route_tables" {
  count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : var.number_of_zone
  vpc_id      = module.vswitch.vpc-id
  route_table_name        = "rt-${count.index}"
  description = "hubvpc internal route tables, nexthop to fortigate port 2-eni created with terraform."
}
// do not use count.index to associate routing table to vswitch , as it will happen at same-time which will fail
// during destroy time, so associate routing table to vswitch seperately use two resource block. 
// each block count max = 1 regardless the number_of_zone =2 

resource "alicloud_route_table_attachment" "custom_route_table_attachment_internal_0" {
// depends_on =[time_sleep.wait_60_seconds_after_create_internal_a_vswitch]
  count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : 1
  vswitch_id     =  alicloud_vswitch.internal_a[0].id
  route_table_id =  alicloud_route_table.custom_route_tables[0].id
}

resource "alicloud_route_table_attachment" "custom_route_table_attachment_internal_1" {
 // during destroy time
  count= var.number_of_zone==2 ? (var.custom_rt==0 ? 0 : 1) : 0
  depends_on =[alicloud_route_table_attachment.custom_route_table_attachment_internal_0]
  vswitch_id     = alicloud_vswitch.internal_a[1].id 
  route_table_id = alicloud_route_table.custom_route_tables[1].id 
}
resource "alicloud_route_entry" "internal_rt_default_route_to_eni" {
  depends_on            = [alicloud_network_interface.PrimaryFortiGateInterface1]
  count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : var.number_of_zone
  route_table_id        = alicloud_route_table.custom_route_tables[count.index].id
  destination_cidrblock = var.default_egress_route
  nexthop_type          = "NetworkInterface"
  name                  = alicloud_network_interface.PrimaryFortiGateInterface1[count.index].id
  nexthop_id            = alicloud_network_interface.PrimaryFortiGateInterface1[count.index].id
}
