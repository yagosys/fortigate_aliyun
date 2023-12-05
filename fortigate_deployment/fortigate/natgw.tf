resource "alicloud_nat_gateway" "nat_gateway" {
    count = var.natgw
    vpc_id =module.vswitch.vpc-id
    name = "NatGateway-${module.random_string.random-string}"
    nat_type = "Enhanced"
    payment_type     = "PayAsYouGo"
    vswitch_id="${alicloud_vswitch.external_a[count.index].id}"
}

//SNAT entries
resource "alicloud_snat_entry" "snat_one" {
    count = var.natgw
    snat_table_id = alicloud_nat_gateway.nat_gateway[count.index].snat_table_ids
    source_vswitch_id = "${alicloud_vswitch.external_a[count.index].id}"
    snat_ip = "${alicloud_eip.eip_snat_one[count.index].ip_address}"
    depends_on = ["alicloud_eip_association.eip_asso_snat_one"]
}
resource "alicloud_snat_entry" "snat_two" {
    count = var.natgw
    snat_table_id = alicloud_nat_gateway.nat_gateway[count.index].snat_table_ids
    source_vswitch_id = "${alicloud_vswitch.external_a[1].id}"
    snat_ip = "${alicloud_eip.eip_snat_one[count.index].ip_address}"
    depends_on = ["alicloud_eip_association.eip_asso_snat_one"]
}

resource "alicloud_snat_entry" "snat_three" {
    count = var.mgmt_eip==0 && var.natgw==1 ? 1 : 0
    snat_table_id = alicloud_nat_gateway.nat_gateway[0].snat_table_ids
    source_vswitch_id = "${alicloud_vswitch.mgmt_a[count.index].id}"
    snat_ip = "${alicloud_eip.eip_snat_one[count.index].ip_address}"
    depends_on = ["alicloud_eip_association.eip_asso_snat_one"]
}
resource "alicloud_snat_entry" "snat_four" {
    count = var.mgmt_eip==0 && var.natgw==1 ? 1 : 0
    snat_table_id = alicloud_nat_gateway.nat_gateway[0].snat_table_ids
    source_vswitch_id = "${alicloud_vswitch.mgmt_a[1].id}"
    snat_ip = "${alicloud_eip.eip_snat_one[count.index].ip_address}"
    depends_on = ["alicloud_eip_association.eip_asso_snat_one"]
}

//EIPs for SNAT
resource "alicloud_eip" "eip_snat_one" {
    count = var.natgw
    bandwidth            = "100"
    internet_charge_type = "PayByTraffic"
}
resource "alicloud_eip_association" "eip_asso_snat_one" {
    count= var.natgw
    allocation_id = "${alicloud_eip.eip_snat_one[count.index].id}"
    instance_id   = "${alicloud_nat_gateway.nat_gateway[count.index].id}"
    depends_on = ["alicloud_eip.eip_snat_one"]
}

output "natgatewayid_vswitch_id" {
   value = var.natgw==1 ? alicloud_nat_gateway.nat_gateway[0].name : null
}

