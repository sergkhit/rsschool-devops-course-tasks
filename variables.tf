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
  default     = "tfstate_rs_task2"
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
  default     = "rs_khit"
}

variable "ec2_ubuntu_ami" {
  description = "user of project"
  type        = string
  default     = "ami-005fc0f236362e99f"
}


