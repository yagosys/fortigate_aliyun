locals {

hubvpc_vswitch_a_cidr_130=cidrsubnet(var.subnet_cidr,8,130)
hubvpc_vswitch_b_cidr_230=cidrsubnet(var.subnet_cidr,8,230)
}

resource "alicloud_vswitch" "landing_for_cen_a_0" {
  count=var.securehub =="1" ? 1 :0
  vswitch_name = "landding_for_cen_a_0"
  vpc_id = module.vswitch.vpc-id 
  cidr_block = local.hubvpc_vswitch_a_cidr_130
  zone_id = var.centr["zone_id_1"]
}

resource "alicloud_vswitch" "landing_for_cen_b_1" {
 count=var.securehub =="1" ? 1 :0
  vswitch_name = "landing_for_cen_1"
  vpc_id = module.vswitch.vpc-id
  cidr_block = local.hubvpc_vswitch_b_cidr_230
  zone_id = var.centr["zone_id_2"]
}

