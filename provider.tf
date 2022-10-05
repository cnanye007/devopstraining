provider "aws" {
  region = "us-east-1"
  profile = "terraform_user"
  shared_config_files = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"] 
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
   }
 }
}
