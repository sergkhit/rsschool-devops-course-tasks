
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
  description = "Public IP of the bastion server"
  value       = aws_instance.rs-task-bastion_host.public_ip
}

output "rs-task-k3s_master_private_ip" {
  description = "private ip from k3s-master"
  value       = aws_instance.rs-task-k3s-master.private_ip
}

output "rs-task-k3s_worker1_private_ip" {
  description = "private ip from k3s-worker1"
  value       = aws_instance.rs-task-k3s-worker1.private_ip
}

output "rs-task-k3s_worker2_private_ip" {
  description = "private ip from k3s-worker2"
  value       = aws_instance.rs-task-k3s-worker2.private_ip
}

output "public_server_a_public_ip" {
  description = "public ip from web server A"
  value       = aws_instance.rs-task-public_server-a.public_ip
}

output "public_server_b_public_ip" {
  description = "public ip from web server B"
  value       = aws_instance.rs-task-public_server-b.public_ip
}

output "public_server_b_private_ip" {
  description = "private ip from web server B"
  value       = aws_instance.rs-task-public_server-b.private_ip
}

output "public_server_a_private_ip" {
  description = "private ip from web server A"
  value       = aws_instance.rs-task-public_server-a.private_ip
}

output "bastion_private_ip" {
  description = "private IP of the bastion server"
  value       = aws_instance.rs-task-bastion_host.private_ip
}
