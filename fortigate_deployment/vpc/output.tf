output "vpc-id" {
 value=alicloud_vpc.vpc.id
}

output "sg-id" {
value = alicloud_security_group.SecGroup.*.id
}

output "route-table-id" {
value = alicloud_vpc.vpc.route_table_id
}
