resource "alicloud_cen_instance" "default" {
 count= var.securehub == "1" ? 1:0
  cen_instance_name        = "${var.centr["cen_instance_name"]}"
  description = "created by terraform"
}

resource "alicloud_cen_transit_router" "default" {
 count= var.securehub == "1" ? 1:0
  transit_router_name       = "${var.centr["cen_tr_name"]}-${var.centr["cen_region"]}"
  cen_id     = alicloud_cen_instance.default[count.index].id
}

