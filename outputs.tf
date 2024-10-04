output "state_s3_bucket_name" {
  value = aws_s3_bucket.state_s3_bucket.bucket
}

output "aws_region" {
  value       = var.aws_region
  description = "AWS region"
}

