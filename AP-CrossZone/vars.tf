variable "access_key" {
  type    = string
  default = ""
}

variable "secret_key" {
  type    = string
  default = ""
}

variable "fgt1_zone_index" {
  type = string
  default =1
}

variable "fgt2_zone_index" {
  type = string
  default = 2 
}

variable "region" {
  type    = string
  default = "cn-hongkong" //Default Region
}

variable "fgt1_availability_zone" {
  type = string
  default = "cn-hongkong-b"
}

variable "fgt2_availability_zone" {
  type = string
  default = "cn-hongkong-c"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/8"
}

variable "vswitch_a_cidr_1" {
  type    = string
  default = "10.0.11.0/24"
}

variable "vswitch_a_cidr_2" {
  type    = string
  default = "10.0.12.0/24"
}

variable "vswitch_a_cidr_3" {
  type    = string
  default = "10.0.13.0/24"
}

variable "vswitch_a_cidr_4" {
  type    = string
  default = "10.0.14.0/24"
}

variable "vswitch_b_cidr_1" {
  type    = string
  default = "10.0.21.0/24"
}

variable "vswitch_b_cidr_2" {
  type    = string
  default = "10.0.22.0/24"
}

variable "vswitch_b_cidr_3" {
  type    = string
  default = "10.0.23.0/24"
}

variable "vswitch_b_cidr_4" {
  type    = string
  default = "10.0.24.0/24"
}

variable "default_egress_route" {
   type   = string
   default = "0.0.0.0/0"
}

variable "cluster_name" {
  type    = string
  default = "FG-AP"
}

// Configure the Alicloud Provider

provider "alicloud" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
  version    = "=1.70.2"
}

variable "instance_ami" {
 type    = string
  default = "m-j6cbretxym0yidwzk1hs" // this is BYOL 6.4.1 for cn-hongkong
}

variable "instance" {
  type    = string
 
  default = "ecs.c6.2xlarge" //this is 8Core16G
}

//Get Instance types with min requirements in the region.
//If left with no instance_type_family the return may include shared instances.
data "alicloud_instance_types" "types_ds" {
  cpu_core_count       = 8
  memory_size          = 16
  instance_type_family = var.instance //ecs.c5 is default
}

data "alicloud_account" "current" {
}

data "template_file" "setupPrimary" {
  template = "${file("${path.module}/ConfigScripts/primaryfortigateconfigscript")}"
  vars = {
    region     = "${var.region}",
    account_id = "${data.alicloud_account.current.id}"
  }
}


variable "primary_fortigate_private_ip" {

  type    = string
  default = "10.0.11.11"
}



//for SecondaryFortigate
data "template_file" "setupSecondary" {
  template = "${file("${path.module}/ConfigScripts/secondaryfortigateconfigscript")}"
  vars = {
    region     = "${var.region}",
    account_id = "${data.alicloud_account.current.id}"
  }
}

variable "secondary_fortigate_private_ip" {
  type    = string
  default = "10.0.21.12"
}
    
