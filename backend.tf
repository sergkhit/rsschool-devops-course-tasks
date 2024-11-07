terraform {
  backend "s3" {
    bucket = "rs-tfstate-khit"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}