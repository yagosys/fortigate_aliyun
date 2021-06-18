terraform {
  required_providers {
    fortios = {
      source = "fortinetdev/fortios"
      version = "1.13.1"
    }
  }
}




resource "fortios_system_setting_dns" "test1" {
primary = "172.16.95.16"
secondary = "1.1.1.1"
}
