variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# variable "avail_zone" {
#   description = "availability_zone"
#   default     = "a"
#   type        = string
# }

variable "aws_instance_pub" {
  description = "instance_type"
  type        = string
  default     = "t2.micro"
}

variable "aws_instance_k3s" {
  description = "instance_type"
  type        = string
  default     = "t3.small"
}

variable "aws_id" {
  description = "AWS account ID"
  type        = string
  default     = "905418277051"
}

variable "github_repo" {
  description = "github repository"
  type        = string
  default     = "rsschool-devops-course-tasks"
}

variable "github_username" {
  description = "github username"
  type        = string
  default     = "sergkhit"
}

variable "iam_role_github_actions" {
  description = "IAM role GitHub Actions"
  type        = string
  default     = "GithubActionsRole"
}

variable "s3_bucket" {
  description = "S3 bucket name"
  default     = "tfstate_rs_task"
  type        = string
}

variable "project" {
  description = "name of project"
  type        = string
  default     = "905418277051"
}

variable "user_owner" {
  description = "user of project"
  type        = string
  default     = "rs_sergkhit"
}

variable "ec2_ubuntu_ami" {
  description = "user of project"
  type        = string
  default     = "ami-005fc0f236362e99f"
}

variable "ec2_amazon_linux_ami" {
  description = "EC2 Instance Image for Bastion Host and Testing"
  default     = "ami-097c5c21a18dc59ea"
}

variable "k8s_domain_name" {
  type    = string
  default = "example.com"
}

variable "k8s_subdomain_name" {
  type    = string
  default = "k8s.example.com"
}

variable "grafana-password" {
  description = "grafana-password"
  type        = string
  sensitive   = true
  default     = "task9pass"
}

