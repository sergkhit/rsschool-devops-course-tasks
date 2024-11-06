# set provider
provider "aws" {
  region = var.aws_region
}

resource "random_password" "k3s_token" {
  length  = 32
  special = false
  upper   = false
  lower   = true
  numeric = true
}

