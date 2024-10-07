terraform {
  backend "s3" {
    bucket = var.s3_bucket
    key    = "terraform.tfstate"
    region = var.aws_region
  }
}