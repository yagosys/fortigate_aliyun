resource "alicloud_cen_transit_router_route_table" "default-North-South" {
  count=var.securehub=="1" ? 1:0
  transit_router_id = alicloud_cen_transit_router.default[count.index].transit_router_id
  transit_router_route_table_name="${var.centr["cen_tr_name"]}-${var.centr["cen_tr_table_name_default"]}"
}

resource "alicloud_cen_transit_router_route_table" "East-West" {
  count=var.securehub=="1" ? 1:0
  transit_router_id = alicloud_cen_transit_router.default[count.index].transit_router_id
  transit_router_route_table_name="${var.centr["cen_tr_name"]}-${var.centr["cen_tr_table_name_East-West"]}"
}

