terraform {
  required_providers {
    fortios = {
      source  = "fortinetdev/fortios"
      version = "1.13.1"
    }
  }
}


resource "fortios_firewall_policy" "toweb8080" {
  action     = "accept"
  logtraffic = "utm"
  name       = "policys1"
  policyid   = 2
  schedule   = "always"

  dstaddr {
    name = "web8080"
  }

  dstintf {
    name = "port2"
  }

  service {
    name = "ALL"
  }

  srcaddr {
    name = "all"
  }

  srcintf {
    name = "port1"
  }
}


