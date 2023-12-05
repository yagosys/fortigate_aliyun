data "alicloud_zones" "default" {
available_instance_type = var.instance_type != "auto" ? var.instance_type : coalesce(length(data.alicloud_zones.default_hfc6.zones) >1  ? data.alicloud_zones.default_hfc6.available_instance_type : "", length(data.alicloud_zones.default_c5.zones) >1  ? data.alicloud_zones.default_c5.available_instance_type : "", length(data.alicloud_zones.default_hfc5.zones) > 1 ?data.alicloud_zones.default_hfc5.available_instance_type : "", length(data.alicloud_zones.default_sn1ne.zones) >1 ?data.alicloud_zones.default_sn1ne.available_instance_type : "")
}

data "alicloud_zones" "default_sn1ne" {
 available_instance_type = var.instance_type !="auto" ? var.instance_type : element(concat([for instance  in data.alicloud_instance_types.types_ds.instance_types.*.id : instance if (contains(["ecs.sn1ne.2xlarge"], instance))],["ecs.hfc6.placehold"]),0)
 available_resource_creation = "VSwitch"
}
data "alicloud_zones" "default_hfc6" {
 available_instance_type = var.instance_type !="auto" ? var.instance_type : element(concat([for instance  in data.alicloud_instance_types.types_ds.instance_types.*.id : instance if (contains(["ecs.hfc6.2xlarge"], instance))],["ecs.hfc6.placehold"]),0)
 available_resource_creation = "VSwitch"
}
data "alicloud_zones" "default_c5" {
 available_instance_type = var.instance_type !="auto" ? var.instance_type : element(concat([for instance  in data.alicloud_instance_types.types_ds.instance_types.*.id : instance if (contains(["ecs.c5.2xlarge"], instance))],["ecs.hfc6.placehold"]),0)
 available_resource_creation = "VSwitch"
}
data "alicloud_zones" "default_hfc5" {
 available_instance_type = var.instance_type !="auto" ? var.instance_type : element(concat([for instance  in data.alicloud_instance_types.types_ds.instance_types.*.id : instance if (contains(["ecs.hfc5.2xlarge"], instance))],["ecs.hfc6.placehold"]),0)
 available_resource_creation = "VSwitch"
}
data "alicloud_instance_types" "types_ds" {
  cpu_core_count       = var.cpu_core_count 
  memory_size          = var.memory_size
  eni_amount =var.eni_amount 
}
data "alicloud_images" "ecs_image" {
  count = var.image_id=="auto"? 1:0
  owners = "marketplace"
  most_recent = true
  name_regex = var.most_recent_image_search_string_from_marketplace
}
