
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.TFvpc.id
}

# output "public_subnet_ids" {
#   description = "IDs of the public subnets"
#   value       = [aws_subnet.TFpublic-a.id, aws_subnet.TFpublic-b.id]
# }

# output "private_subnet_ids" {
#   description = "IDs of the public subnets"
#   value       = [aws_subnet.TFprivate-a.id, aws_subnet.TFprivate-b.id]
# }

# output "security_group_id_bastion" {
#   description = "Security Group ID that allows SSH"
#   value       = aws_security_group.rs-task2-bastion.id
# }

output "bastion_public_ip" {
  description = "Public IP of the bastion servers"
  value       = aws_instance.rs-task2-bastion_host.public_ip
}

output "public_server_a_public_ip" {
  description = "public ip from web server A"
  value       = aws_instance.rs-task2-public_server-a.public_ip
}

output "public_server_a_private_ip" {
  description = "private ip from web server A"
  value       = aws_instance.rs-task2-public_server-a.private_ip
}

output "private_server_a_private_ip" {
  description = "private ip from database server A"
  value       = aws_instance.rs-task2-private_server-a.private_ip
}

output "public_server_b_public_ip" {
  description = "public ip from web server B"
  value       = aws_instance.rs-task2-public_server-b.public_ip
}

output "public_server_b_private_ip" {
  description = "private ip from web server B"
  value       = aws_instance.rs-task2-public_server-b.private_ip
}

output "private_server_b_private_ip" {
  description = "private ip from database server b"
  value       = aws_instance.rs-task2-private_server-b.private_ip
}