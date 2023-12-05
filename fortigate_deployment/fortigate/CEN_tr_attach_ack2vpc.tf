resource "alicloud_cen_transit_router_vpc_attachment" "atta_vpc2" {
 count =var.securehub == "1" ? 1:0
 depends_on =[alicloud_cen_transit_router_vpc_attachment.atta_vpc1,alicloud_cen_instance.default]
  cen_id            = alicloud_cen_instance.default[count.index].id
  transit_router_id = alicloud_cen_transit_router.default[count.index].transit_router_id
  vpc_id = module.vpc2.vpc-id
  zone_mappings {
   zone_id = var.centr["zone_id_1"]
    vswitch_id = alicloud_vswitch.vpc2_vswitch0[count.index].id
  }
  zone_mappings {
    zone_id = var.centr["zone_id_2"] 
    vswitch_id = alicloud_vswitch.vpc2_vswitch1[count.index].id
  }
  transit_router_attachment_description = "terraform"

}

resource "alicloud_cen_transit_router_route_table_propagation" "propagte_spoke_a_vpc_route_East-West_rt" {
  count =var.securehub == "1" ? 1:0
  transit_router_route_table_id = alicloud_cen_transit_router_route_table.East-West[count.index].transit_router_route_table_id
  transit_router_attachment_id = alicloud_cen_transit_router_vpc_attachment.atta_vpc2[count.index].transit_router_attachment_id
}

resource "alicloud_cen_transit_router_route_table_association" "associate_spoke_vpc_a_to_tr_rtb_default-North-South" { 

  count =var.securehub == "1" ? 1:0
  transit_router_route_table_id = alicloud_cen_transit_router_route_table.default-North-South[count.index].transit_router_route_table_id
  transit_router_attachment_id = alicloud_cen_transit_router_vpc_attachment.atta_vpc2[count.index].transit_router_attachment_id
}


variable "vpc2_subnet_cidr2" {
default= ""
}
module "vpc2" {
  source  = "../vpc"
  vpc_cidr=var.vpc2_subnet_cidr2
}
