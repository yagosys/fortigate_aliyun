resource "alicloud_instance" "PrimaryFortigate" {
 depends_on = [module.ram_role.alicloud_ram_role_policy_attachment]
 count= var.number_of_fortigate
 instance_name="fortigate${count.index}-${module.random_string.random-string}"
 availability_zone =var.number_of_zone==2 ? element(data.alicloud_zones.default.zones.*.id,count.index) : data.alicloud_zones.default.zones[0].id
 security_groups   = module.vswitch.sg-id
 instance_type = var.instance_type != "auto" ? var.instance_type : coalesce(length(data.alicloud_zones.default_hfc6.zones) >1  ? data.alicloud_zones.default_hfc6.available_instance_type : "", length(data.alicloud_zones.default_c5.zones) >1  ? data.alicloud_zones.default_c5.available_instance_type : "", length(data.alicloud_zones.default_hfc5.zones) > 1 ?data.alicloud_zones.default_hfc5.available_instance_type : "", length(data.alicloud_zones.default_sn1ne.zones) >1 ?data.alicloud_zones.default_sn1ne.available_instance_type : "")

 vswitch_id           = var.number_of_zone==1 ? alicloud_vswitch.external_a[0].id : alicloud_vswitch.external_a[count.index].id
 role_name =module.ram_role.ram_role-id
 private_ip=local.cidr_block_ip["external"][count.index]
 internet_max_bandwidth_out=var.fortigate["internet_max_bandwidth_out"][count.index]
 user_data     = templatefile( 

"config-active.conf",
{
port1_ip=local.cidr_block_ip["external"][count.index],

port1_mask=cidrnetmask(local.cidr_block["external"][length(local.cidr_block["external"])-1]),
defaultgwy=local.fortigate["defaultgwy"][count.index],

port2_ip=local.cidr_block_ip["internal"][count.index],

port2_mask=cidrnetmask(local.cidr_block["internal"][length(local.cidr_block["internal"])-1]),
port2gateway=local.fortigate["port2gateway"][count.index],

port3_ip=local.cidr_block_ip["ha"][count.index],

port3_mask=cidrnetmask(local.cidr_block["ha"][length(local.cidr_block["ha"])-1]),

port4_ip=local.cidr_block_ip["mgmt"][count.index],

port4_mask=cidrnetmask(local.cidr_block["mgmt"][length(local.cidr_block["mgmt"])-1]),

internal_cidr_mask = cidrnetmask(local.cidr_block["internal_cidr"][length(local.cidr_block["internal_cidr"])-1]),
internal_cidr=cidrhost(local.cidr_block["internal_cidr"][length(local.cidr_block["internal_cidr"],)-1],0),

ha_priority=var.fortigate["ha_priority"][count.index],
mgmt_gateway_ip=local.fortigate["mgmt_gateway_ip"][count.index],
ha_peer_ip=local.fortigate["ha_peer_ip"][count.index],

 spoke_vpc1_cidr=cidrhost(var.vpc1_subnets,0)
 spoke_vpc1_cidr_mask = cidrnetmask(var.vpc1_subnets)

 spoke_vpc2_cidr=cidrhost(var.vpc2_subnets,0)
 spoke_vpc2_cidr_mask = cidrnetmask(var.vpc2_subnets)

type="byol",
license_file=file(var.fortigate["license_file"][count.index]),
hostname    =     var.fortigate["hostname"][count.index],
}
)
image_id = var.image_id=="auto" ?  data.alicloud_images.ecs_image[0].images.0.id : var.image_id
}

module "ram_role" {
  source = "../ram"
}


module "vswitch" {
  source  = "../vpc"
  vpc_cidr=var.subnet_cidr
}

module "random_string" {
 source = "../global"
}

