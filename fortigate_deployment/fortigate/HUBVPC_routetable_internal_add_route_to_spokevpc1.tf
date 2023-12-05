#need to add spoke vpc on each zone's routing table. each zone has one routing table.
resource "alicloud_route_entry" "to_vpc1" {
  count                 = var.securehub=="1" ? (var.number_of_zone==2? 2:0) : 0
  depends_on  = [alicloud_cen_transit_router_vpc_attachment.hubvpc,time_sleep.wait_90_seconds_after_create_internal_a_vswitch]
  route_table_id        = alicloud_route_table.custom_route_tables[count.index].id
  destination_cidrblock = var.vpc1_subnets
  nexthop_type          = "Attachment"
  name                  = "tf-to_vpc1_vpc_via_tr"
  nexthop_id            = alicloud_cen_transit_router_vpc_attachment.hubvpc[0].transit_router_attachment_id
}


