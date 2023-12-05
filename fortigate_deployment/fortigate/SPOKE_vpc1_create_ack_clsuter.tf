resource "alicloud_security_group" "SecGroup_ack1" {
  count                 =  var.spoke_ack_vpc_1 ==1 ? 1 :0
  description = "SecurityGroup for ACK worknode instance"
  vpc_id      = module.vpc1.vpc-id
}

//Allow All Ingress for Firewall
resource "alicloud_security_group_rule" "allow_all_tcp_ingress_ack1" {
  count                 =  var.spoke_ack_vpc_1 ==1 ? 1 :0
  type              = "ingress"
  ip_protocol       = "all"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "1/-1"
  priority          = 1
  security_group_id = alicloud_security_group.SecGroup_ack1[count.index].id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_cs_managed_kubernetes" "ack_vpc1" {
  count                 =  var.spoke_ack_vpc_1 ==1 ? 1 :0
//  availability_zone     = data.alicloud_zones.default.zones[0].id
  worker_vswitch_ids = [ alicloud_vswitch.vpc1_vswitch0[count.index].id,alicloud_vswitch.vpc1_vswitch1[count.index].id]
  pod_vswitch_ids= [ alicloud_vswitch.vpc1_vswitch0[count.index].id,alicloud_vswitch.vpc1_vswitch1[count.index].id]
  new_nat_gateway       = false
  worker_instance_types = ["${var.worker_instance_type == "" ? data.alicloud_instance_types.types_ds.instance_types.0.id : var.worker_instance_type}"]
  worker_number         = "${var.k8s_worker_number}"
  worker_disk_category  = "${var.worker_disk_category}"
  worker_disk_size      = "${var.worker_disk_size}"
  password              = "${var.ecs_password}"
  pod_cidr              = "${var.vpc1_subnets}"
  service_cidr          = "${var.k8s_service_cidr}"
  slb_internet_enabled  = false
  security_group_id         = alicloud_security_group.SecGroup_ack1[count.index].id

  install_cloud_monitor = false
 // cluster_spec = "ack.pro.small"
  kube_config           = "~/.kube/config_ack1"

  dynamic "addons" {
      for_each = var.cluster_addons_ack1
      content {
        name          = lookup(addons.value, "name", var.cluster_addons_ack1)
        config        = lookup(addons.value, "config", var.cluster_addons_ack1)
        disabled      = lookup(addons.value, "disabled", var.cluster_addons_ack1)
      }
  }
}

variable "cluster_addons_ack1" {
  type = list(object({
    name      = string
    config    = string
    disabled  = bool
  }))

  default = [
    {
      "name"     = "terway-eniip",
      "config"   = "",
      "disabled" = false,
    },
    {  "name"    = "nginx-ingress-controller",
       "config"  = "",
       "disabled" = true,
    }
  ]
}
