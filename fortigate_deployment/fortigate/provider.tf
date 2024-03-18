terraform {
  required_providers {
    alicloud = {
      source  = "hashicorp/alicloud"
      version = "1.211.2"
    }
  }
}

provider "alicloud" {
        profile = var.profile 
        region  = var.region
}

