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

# add helm

terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}