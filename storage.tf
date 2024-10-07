resource "random_string" "my_numbers" {
  length  = 8
  special = false
  upper   = false
  numeric = true
}

resource "aws_s3_bucket" "bucket" {
  bucket = "rs-tf-lab-${random_string.my_numbers.result}"

  tags = {
    Terraform = "true"
    Project   = var.project
    Owner     = var.user_owner
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_acl" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls   = true
  block_public_policy = true
}