resource "alicloud_cen_transit_router_vpc_attachment" "hubvpc" {
 count=var.securehub=="1" ? 1:0
 depends_on =[alicloud_cen_transit_router.default,time_sleep.wait_180_seconds_after_create_Primary_fortigate]
  cen_id            = alicloud_cen_instance.default[count.index].id
  transit_router_id = alicloud_cen_transit_router.default[count.index].transit_router_id
  vpc_id =module.vswitch.vpc-id 
  zone_mappings {
   zone_id = var.centr["zone_id_1"]
    vswitch_id = alicloud_vswitch.landing_for_cen_a_0[count.index].id
  }
  zone_mappings {
    zone_id = var.centr["zone_id_2"]
    vswitch_id = alicloud_vswitch.landing_for_cen_b_1[count.index].id
  }
  transit_router_attachment_description = "terraform"

}


resource "alicloud_cen_transit_router_route_table_propagation" "default_for_hubvpc_East-West" {
 count=var.securehub=="1" ? 1 :0
  transit_router_route_table_id = alicloud_cen_transit_router_route_table.East-West[count.index].transit_router_route_table_id
  transit_router_attachment_id = alicloud_cen_transit_router_vpc_attachment.hubvpc[count.index].transit_router_attachment_id
}


resource "alicloud_cen_transit_router_route_table_association" "default_hub_vpc" {
 count=var.securehub=="1" ? 1 : 0
  transit_router_route_table_id = alicloud_cen_transit_router_route_table.East-West[count.index].transit_router_route_table_id
  transit_router_attachment_id = alicloud_cen_transit_router_vpc_attachment.hubvpc[count.index].transit_router_attachment_id
}


variable "rt_default" {
  default = "0.0.0.0/0"
}
// for config a default route to tr hub-vpc on tf-default for spoke vpc to use
resource "alicloud_cen_transit_router_route_entry" "tr_cen_tf_default_router_entry" {
 count = var.securehub =="1" ? 1:0
  transit_router_route_table_id = alicloud_cen_transit_router_route_table.default-North-South[count.index].transit_router_route_table_id
  transit_router_route_entry_destination_cidr_block = var.rt_default
  transit_router_route_entry_next_hop_type = "Attachment"
  transit_router_route_entry_name = "terraform-tf-default-0.0.0.0"
  transit_router_route_entry_description = "terraform-tf-default-0.0.0.0"
  transit_router_route_entry_next_hop_id = alicloud_cen_transit_router_vpc_attachment.hubvpc[count.index].transit_router_attachment_id
}
