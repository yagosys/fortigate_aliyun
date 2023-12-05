variable "vpc1_subnets" {
 default=""
}

variable "vpc1_vswitch0_subnet" {
  default = ""
}

variable "vpc1_vswitch1_subnet" {
  default = ""
}

resource "alicloud_vswitch" "vpc1_vswitch0" {
count = var.securehub == "1" ? 1 : 0
  vswitch_name = "vswitch0"
  vpc_id = module.vpc1.vpc-id
  cidr_block =var.vpc1_vswitch0_subnet 
   zone_id = var.centr["zone_id_1"]
}

resource "alicloud_vswitch" "vpc1_vswitch1" {
count = var.securehub == "1" ? 1 : 0
  vswitch_name = "vswitch1"
  vpc_id = module.vpc1.vpc-id
  cidr_block = var.vpc1_vswitch1_subnet
  zone_id = var.centr["zone_id_2"]
}
