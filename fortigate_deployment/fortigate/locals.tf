locals {
  fortigate = {
  "defaultgwy" = [cidrhost(local.cidr_block["external"][0],253),
		  cidrhost(local.cidr_block["external"][1],253)]
  "port2gateway" = [cidrhost(local.cidr_block["internal"][0],253),
		    cidrhost(local.cidr_block["internal"][1],253)]
  "mgmt_gateway_ip" = [cidrhost(local.cidr_block["mgmt"][0],253),
		       cidrhost(local.cidr_block["mgmt"][1],253)]
  "ha_peer_ip" = [cidrhost(local.cidr_block["ha"][1],12),
		 cidrhost(local.cidr_block["ha"][0],11)]
  }
}

locals {
cidr_block = {
                external = [
                        var.number_of_zone==2 ? cidrsubnet(var.subnet_cidr,8,11) : cidrsubnet(var.subnet_cidr,8,11),
                        var.number_of_zone==2 ? cidrsubnet(var.subnet_cidr,8,21) : cidrsubnet(var.subnet_cidr,8,11),
                ]
                internal = [
                        var.number_of_zone==2 ? cidrsubnet(var.subnet_cidr,8,12) : cidrsubnet(var.subnet_cidr,8,12),
                        var.number_of_zone==2 ? cidrsubnet(var.subnet_cidr,8,22) : cidrsubnet(var.subnet_cidr,8,12),
                ]
                ha = [
                        var.number_of_zone==2 ?  cidrsubnet(var.subnet_cidr,8,13) :  cidrsubnet(var.subnet_cidr,8,13),
                        var.number_of_zone==2 ? cidrsubnet(var.subnet_cidr,8,23) :  cidrsubnet(var.subnet_cidr,8,13),
                ]
                mgmt = [
                        var.number_of_zone==2 ?  cidrsubnet(var.subnet_cidr,8,14) :  cidrsubnet(var.subnet_cidr,8,14),
                        var.number_of_zone==2 ? cidrsubnet(var.subnet_cidr,8,24) :  cidrsubnet(var.subnet_cidr,8,14),
                ]
                internal_cidr = [
                        var.subnet_cidr
                ]
}
}

locals {
  cidr_block_ip = {
  "external" = [cidrhost(local.cidr_block["external"][0],11),
                  cidrhost(local.cidr_block["external"][1],12)]
  "internal" = [cidrhost(local.cidr_block["internal"][0],11),
                  cidrhost(local.cidr_block["internal"][1],12)]
  "ha" = [cidrhost(local.cidr_block["ha"][0],11),
                  cidrhost(local.cidr_block["ha"][1],12)]
  "mgmt" = [cidrhost(local.cidr_block["mgmt"][0],11),
                  cidrhost(local.cidr_block["mgmt"][1],12)]
 }
}

