variable "custom_rt" {
default=1
validation {
    condition     =  contains([1, 0], var.custom_rt)
    error_message = "Must be 1 or 0, 1 means create custom routing table, 0 means not."
  }
}
variable fortigate {
type =map(any)
    default = {
            hostname=[
		    "fortigate-active",
		    "fortigate-passive",
		]
            license_file=[
		    "./FGVMULTM22000730.lic",
		    "./FGVMULTM22000750.lic",
		]
	    internet_max_bandwidth_out=[
		    "100",
		    "100",
		]
            ha_priority=[
		     "200",
		     "100",
	        ]
  }
    validation {
	condition     = can(var.fortigate["license_file"])
    error_message = "A license file is required."
	}
}
variable subnet_cidr {
 default= ""
 validation {
  //  condition     =  can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}($|/(\\d+))$", var.subnet_cidr))
condition     =  can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}($|/([0-9]{1,2}))$", var.subnet_cidr))
    error_message = "Must be in format like 10.0.0.0/16."
  }
}

variable "default_egress_route" {
  type    = string
  default = "0.0.0.0/0"
}

variable "instance_type" {
default= ""
validation {
  condition = substr(var.instance_type,0,3) == "ecs" || contains(["auto"],var.instance_type)
  error_message= "A instance_type is required, can be auto or start with prefix ecs."
}
}

variable "number_of_fortigate" {
default= 2
validation {
  condition = contains([2,1], var.number_of_fortigate)
  error_message = "Must be 1 or 2."
}
}

variable "number_of_zone" {
default = 1
validation {
    condition     =  contains([2,1, 0], var.number_of_zone)
    error_message = "Must be 0 ,1 or 2 , 0  means do not create additional ENI, 1 means single zone HA, 4 ENI will be created in one zone, 2 means cross zone HA, 4 ENI will be created in each zone." 
  }
}

variable "mgmt_eip" {
default = 1
validation {
    condition     =  contains([1, 0], var.mgmt_eip)
    error_message = "Must be 0 ,1  0  means do not create eip for management port (port4), 1 means create eip for management port."
  }

}

variable "eip" {
default= 1
validation {
   condition = contains ([1,0], var.eip) 
   error_message = "Must be 0, 1  0 means do not create eip for port1 , 1 means create use eip for active port1 when public internet ip is not set."
}
}

variable "natgw" {
default=0
validation {
   condition = contains ([1,0], var.natgw)
   error_message = "Must be 0, 1  0 means do not create natgw , 1 means create use natgw."
}
}

variable "region" {
default="cn-hongkong"
}

variable "profile" {
default="default"
}

variable "image_id" {
 default=""
 validation {
 	condition = substr(var.image_id,0,2) == "m-" || contains(["auto"],var.image_id)
	error_message= "Must be auto or image with prefix m-."
 }
}

variable "most_recent_image_search_string_from_marketplace" {
   type = string
   default = ""
}

variable "cpu_core_count"  {
 default=""
}

variable "memory_size" {
 default = ""
}

variable "eni_amount" {
 default = ""
}

variable "securehub" {
 default = "1"
}

variable "spoke_linux_vpc_1" {
 default = 0
}
variable "spoke_linux_vpc_2" {
 default = 0
}
variable "spoke_ack_vpc_1" {
 default = 0
}
