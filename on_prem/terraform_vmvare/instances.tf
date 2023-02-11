module "vm1" {
  source = "../modules_terraform/"
  vm_name = "app"
  disk_size = 40
  vm_ip = "192.168.5.100"
  vm_cidr = 24
  default_gw = "192.168.5.254"
  dns_list = ["192.168.5.254"]
  memory = 2048
  cpu_number = 2
}

module "vm2" {
  source = "../modules_terraform/"
  vm_name = "mariadb"
  disk_size = 60
  vm_ip = "192.168.5.101"
  vm_cidr = 24
  default_gw = "192.168.5.254"
  dns_list = ["192.168.5.254"]
  memory = 2048
  cpu_number = 2
}
