provider "aws" {
  region = "us-east-1"
  profile = "terraform_user"
  AWS_SHARED_CREDENTIALS_FILE = "/home/ec2-user/.aws/credentials"
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
   }
 }
}
