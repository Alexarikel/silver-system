module "servers" {
  source = "../modules_aws/servers"
  db_pass = var.db_pass
  db_user = var.db_user
  db_name = var.db_name
  ssh_key = var.ssh_key
}

module "s3_bucket" {
  source = "../modules_aws/s3_bucket"
  bucket_name = var.bucket_name
}

variable "bucket_name" {
  description = "Name of s3 bucket"
  type = string
}

variable "ssh_key" {
  description = "ssh-key for AWS instances"
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
  description = "Password for DB"
  type = string
  sensitive = true
}
