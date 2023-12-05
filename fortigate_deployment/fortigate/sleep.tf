resource "time_sleep" "wait_60_seconds_after_create_primary_fortigate_interface3" {
 depends_on = [alicloud_network_interface.PrimaryFortiGateInterface3]
   create_duration = "30s"
}

resource "time_sleep" "wait_60_seconds_after_create_internal_a_vswitch" {
 count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : var.number_of_fortigate
 depends_on = [alicloud_vswitch.internal_a]
   create_duration =  "60s"
}

resource "time_sleep" "wait_30_seconds_after_create_internal_a_vswitch" {
 count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : var.number_of_fortigate
 depends_on = [alicloud_vswitch.internal_a]
   create_duration =  "30s"
}

resource "time_sleep" "wait_45_seconds_after_create_internal_a_vswitch" {
 count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : var.number_of_fortigate
 depends_on = [alicloud_vswitch.internal_a]
   create_duration =  "45s"
}

resource "time_sleep" "wait_90_seconds_after_create_internal_a_vswitch" {
 count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : var.number_of_fortigate
 depends_on = [alicloud_vswitch.internal_a]
   create_duration =  "90s"
}

resource "time_sleep" "wait_120_seconds_after_create_internal_a_vswitch" {
 count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : var.number_of_fortigate
 depends_on = [alicloud_vswitch.internal_a]
   create_duration =  "120s"
}

resource "time_sleep" "wait_180_seconds_after_create_Primary_fortigate" {
//this is for give fortigate to apply license and form HA before associate EIP
 depends_on = [alicloud_instance.PrimaryFortigate]
 count = var.number_of_fortigate==2? 1:0
 create_duration = "180s"
}
