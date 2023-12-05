resource "alicloud_vswitch" "internal_a" {
 name="internal_a"
 count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : var.number_of_zone
 vpc_id =module.vswitch.vpc-id
 cidr_block=local.cidr_block["internal"][count.index]
 zone_id=element(data.alicloud_zones.default.zones.*.id,count.index)
}

resource "alicloud_vswitch" "external_a" {
 name="external_a"
 count= var.number_of_zone==0 ? 1: var.number_of_zone
 vpc_id =module.vswitch.vpc-id
 cidr_block=local.cidr_block["external"][count.index]
 zone_id=element(data.alicloud_zones.default.zones.*.id,count.index)
}

resource "alicloud_vswitch" "ha_a" {
 name="ha_a"
 count=var.number_of_zone
 vpc_id =module.vswitch.vpc-id
 cidr_block=local.cidr_block["ha"][count.index]
 zone_id=element(data.alicloud_zones.default.zones.*.id,count.index)
}

resource "alicloud_vswitch" "mgmt_a" {
 name="mgmt_a"
 count=var.number_of_zone
 vpc_id =module.vswitch.vpc-id
 cidr_block=local.cidr_block["mgmt"][count.index]
 zone_id=element(data.alicloud_zones.default.zones.*.id,count.index)
}
