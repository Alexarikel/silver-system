locals {
  ssh_key = var.ssh_key
}

resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "web-pub" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = var.pub_sub_name
  }
}

resource "aws_route_table" "vpc-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "vpc-rt"
  }
}

resource "aws_route_table_association" "web-pub-associat" {
  subnet_id      = aws_subnet.web-pub.id
  route_table_id = aws_route_table.vpc-rt.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "igw"
  }
}

resource "aws_security_group" "allow_web" {
  name        = var.web-sg
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.web-sg
  }
}

resource "aws_security_group" "private-sg" {
  name        = var.private-sg
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.private-sg
  }
}

resource "aws_security_group" "rds-sg" {
  name        = var.rds-sg
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "Mariadb"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = [join("/", [aws_instance.web-server.public_ip, "32"]), join("/", [aws_instance.web-server.private_ip, "32"])]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.rds-sg
  }
}

resource "aws_network_interface" "web-ni" {
  subnet_id       = aws_subnet.web-pub.id
  security_groups = [aws_security_group.allow_web.id]
}

#create public ip
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-ni.id
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_instance" "web-server" {
  ami           = var.ami
  instance_type = var.instance_type
  availability_zone = "us-east-1a"
  key_name = var.key_name
  depends_on = [aws_eip.one]
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web-ni.id
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = var.instance_name
  }

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(local.ssh_key)
      host        = aws_instance.web-server.public_ip
    }
  }
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${var.ssh_user}  -i ${aws_instance.web-server.public_ip}, --private-key ${local.ssh_key} ../playbook.yml" 
  }
}

resource "aws_subnet" "private_sub" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1f"
  tags = {
    Name = var.private_sub_name
  }
}

resource "aws_subnet" "private_sub2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }
  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "private-associat" {
  subnet_id      = aws_subnet.private_sub.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_eip" "nat_eip" {
  vpc        = true
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.web-pub.id
  tags = {
    Name        = "nat-gw"
  }
}

resource "aws_instance" "app-server" {
  ami           = var.ami
  instance_type = var.instance_type
  availability_zone = "us-east-1f"
  security_groups = [aws_security_group.private-sg.id]
  key_name = var.key_name
  subnet_id = aws_subnet.private_sub.id
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = var.private_inst_name
  }
}

resource "aws_db_subnet_group" "db_sub_group" {
  name       = "main"

  subnet_ids = [
    aws_subnet.private_sub.id, aws_subnet.private_sub2.id
  ]
}

resource "aws_db_instance" "database" {
  db_subnet_group_name = aws_db_subnet_group.db_sub_group.name
  availability_zone = "us-east-1f"
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  allocated_storage    = 10
  db_name              = var.db_name
  engine               = var.db_engine
  instance_class       = "db.t3.micro"
  username             = var.db_user
  password             = var.db_pass
  skip_final_snapshot  = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "local_file" "inventory" {
 filename = "../host/host"
 content = <<EOF
webserver:${aws_instance.web-server.public_ip}
rds:${aws_db_instance.database.endpoint}
EOF

  provisioner "local-exec" {
    command = "cd ~/final_project/aws/host/ && if [ $(git status --short | wc -l) != 0 ]; then git add host && git commit -m '.' && git push; else echo 'Nothing to commit'; fi"  
  }
}
