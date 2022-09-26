provider "aws" {
  region = "us-east-1"
  profile = "terraform-user"
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}