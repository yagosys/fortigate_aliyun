resource "alicloud_instance" "spoke-linux-vpc2" {
  count = var.spoke_linux_vpc_2 ==1 ? 1 :0
  image_id                   = "ubuntu_18_04_x64_20G_alibase_20200521.vhd"
  internet_max_bandwidth_out = 0
  security_groups            = module.vpc2.sg-id
  instance_type = "ecs.hfc6.large"
  vswitch_id    = alicloud_vswitch.vpc2_vswitch0[count.index].id
  password      = "Welcome.123"

}
