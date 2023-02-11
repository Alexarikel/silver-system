module "servers" {
  source = "../modules_aws/servers"
  db_pass = var.db_pass
  db_user = var.db_user
  db_name = var.db_name
}

variable "db_name" {
  description = "Name of DB"
  type = string
}

variable "db_user" {
  description = "Username for DB"
  type = string
}

variable "db_pass" {
  description = "Password of DB"
  type = string
  sensitive = true
}
