variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment (prod, dev, e t.c.)"
  type        = string
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
  default     = "rs-tfstate-khit"
  type        = string
}