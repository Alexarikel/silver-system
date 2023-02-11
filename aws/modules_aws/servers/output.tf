output "web_public_ip" {
  description = "public ip address of the deployed web-server"
  value       = aws_instance.web-server.public_ip
}

output "app_private_ip" {
  description = "private ip address of the deployed application server"
  value       = aws_instance.app-server.private_ip
}

output "db_instance_addr" {
  description = "address of the db instance"
  value       = aws_db_instance.database.endpoint
}
