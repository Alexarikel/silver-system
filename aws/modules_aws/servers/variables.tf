variable "ssh_key" {
  description = "ssh-key for AWS instances"
  default = "~/.ssh/web_study.pem"
}

variable "ssh_user" {
  description = "Username in aws with a sudo permissions"
  default = "ubuntu"
}

variable "vpc_name" {
  description = "Name of vpc"
  type = string
  default = "my-vpc"
}

variable "pub_sub_name" {
  description = "Name of public subnet"
  type = string
  default = "web_pub"
}

variable "web-sg" {
  type = string
  description = "Allow Web traffic"
  default = "allow_web"
}

variable "private-sg" {
  type = string
  description = "Allow traffic inside private subnet"
  default = "private-sg"
}

variable "rds-sg" {
  type = string
  description = "Allow traffic to RDS instance"
  default = "rds"
}

variable "ami" {
  description = "AWS machine image to use for ec2 instance"
  type = string
  default = "ami-00874d747dde814fa" # Ubuntu 22.04 LTS amd64 
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "key_name" {
  description = "AWS ssh key"
  type = string
  default = "web-study"
}

variable "instance_name" {
  description = "Name of the AWS instance"
  type = string
  default = "web-server"
}

variable "private_inst_name" {
  description = "Name of the instance in private subnet"
  type = string
  default = "app-server"
}

variable "private_sub_name" {
  description = "Name of public subnet"
  type = string
  default = "private_sub"
}

variable "db_engine" {
  description = "Database engine"
  type = string
  default = "mysql"
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
