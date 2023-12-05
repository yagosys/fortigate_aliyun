variable "vpc2_subnets" {
 default="10.0.0.0/16"
}

variable "vpc2_vswitch0_subnet" {
  default = "10.0.0.0/24"
}

variable "vpc2_vswitch1_subnet" {
  default = "10.0.1.0/24"
}

resource "alicloud_vswitch" "vpc2_vswitch0" {
count = var.securehub == "1" ? 1 : 0
  vswitch_name = "vswitch0"
  vpc_id = module.vpc2.vpc-id
  cidr_block =var.vpc2_vswitch0_subnet 
   zone_id = var.centr["zone_id_1"]
}

resource "alicloud_vswitch" "vpc2_vswitch1" {
count = var.securehub == "1" ? 1 : 0
  vswitch_name = "vswitch1"
  vpc_id = module.vpc2.vpc-id
  cidr_block = var.vpc2_vswitch1_subnet
  zone_id = var.centr["zone_id_2"]
}
