provider "aws" {
  region = "us-east-1"
  profile = "terraform_user"
  shared_config_files = ["/home/ec2-user/.aws/config"]
  shared_credentials_files = ["/home/ec2-user/.aws/credentials"] 
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
   }
 }
}
