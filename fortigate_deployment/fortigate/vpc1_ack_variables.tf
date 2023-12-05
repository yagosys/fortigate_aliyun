//# common variables

variable "availability_zone" {
  description = "The available zone to launch ecs instance and other resources."
  default     = ""
}


variable "worker_instance_type" {
  description = "The ecs instance type used to launch worker nodes. Default from instance typs datasource."
  default     = "ecs.hfc6.xlarge"
}

variable "worker_disk_category" {
  description = "The system disk category used to launch one or more worker nodes."
  default     = "cloud_efficiency"
}

variable "worker_disk_size" {
  description = "The system disk size used to launch one or more worker nodes."
  default     = "20"
}

variable "ecs_password" {
  description = "The password of instance."
  default     = "Welcome.123"
}

variable "k8s_worker_number" {
  description = "The number of worker nodes in each kubernetes cluster."
  default     = 2
}

variable "k8s_name_prefix" {
  description = "The name prefix used to create several kubernetes clusters. Default to variable `example_name`"
  default     = ""
}

variable "k8s_pod_cidr" {
  description = "The kubernetes pod cidr block. It cannot be equals to vpc's or vswitch's and cannot be in them."
  default     = "10.1.0.0/23"
}

variable "k8s_service_cidr" {
  description = "The kubernetes service cidr block. It cannot be equals to vpc's or vswitch's or pod's and cannot be in them."
  default     = "172.21.0.0/20"
}



