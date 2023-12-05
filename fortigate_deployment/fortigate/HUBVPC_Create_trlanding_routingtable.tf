variable "tr_landing_route_entry" {
  default = "0.0.0.0/0"
}

resource "alicloud_route_table" "tr_landing_rt" {
  count       = var.securehub=="1" ? 1:0 
  vpc_id      = module.vswitch.vpc-id
  route_table_name        = "tr_landing_rt"
}

resource "alicloud_route_table_attachment" "tr_landing_attachment" {
  count       = var.securehub=="1" ? 1:0
  vswitch_id     = alicloud_vswitch.landing_for_cen_a_0[count.index].id

  route_table_id = alicloud_route_table.tr_landing_rt[count.index].id
}

resource "alicloud_route_table_attachment" "tr_landing_attachment_1" {
  depends_on = [alicloud_route_table_attachment.tr_landing_attachment]
  count       = var.securehub=="1" ? 1:0 
  vswitch_id     = alicloud_vswitch.landing_for_cen_b_1[count.index].id
  route_table_id = alicloud_route_table.tr_landing_rt[count.index].id
}


