resource "alicloud_route_entry" "spoke_a_default_vpc2" {
 count = var.securehub=="1" ? 1 : 0
 depends_on = [alicloud_cen_transit_router_vpc_attachment.atta_vpc2]
 route_table_id        = module.vpc2.route-table-id 
  destination_cidrblock = var.default_egress_route
  nexthop_type          = "Attachment"
  name                  = "tf-default_to_tr"
  nexthop_id            = alicloud_cen_transit_router_vpc_attachment.atta_vpc2[count.index].transit_router_attachment_id
}


