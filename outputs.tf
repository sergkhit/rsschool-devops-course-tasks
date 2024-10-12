
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.TFvpc.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [aws_subnet.TFpublic-a.id, aws_subnet.TFpublic-b.id]
}

output "private_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [aws_subnet.TFprivate-a.id, aws_subnet.TFprivate-b.id]
}

output "security_group_id_ssh" {
  description = "Security Group ID that allows SSH"
  value       = aws_security_group.rs-task2-ssh_inbound.id
}

# output "security_group_id_http" {
#   description = "Security Group ID that allows HTTP"
#   value       = aws_security_group.http_inbound.id
# }

# output "security_group_id_http_lb" {
#   description = "Security Group ID that allows HTTP Load Balancing"
#   value       = aws_security_group.lb_http_inbound.id
# }

# output "iam_instance_profile_name" {
#   description = "IAM Instance Profile Name"
#   value       = aws_iam_instance_profile.instance_profile.name
# }

# output "key_name" {
#   description = "Name of the AWS Key Pair"
#   value       = aws_key_pair.rs-tf-ssh-key.key_name
# }

# output "s3_bucket_name" {
#   description = "S3 Bucket Name"
#   value       = aws_s3_bucket.rs-tfstate-khit.id
# }

output "public_instance_ips" {
  description = "Public IPs of the web servers"
  value       = [aws_instance.rs-task2-web_server-a.public_ip, aws_instance.rs-task2-web_server-b.public_ip]
}

