provider "aws" {
  region = "us-east-1"
  #profile = "terraform-user"
  AWS_ACCESS_KEY_ID = "AKIAY5V7XK53MLQTLQOA"
  AWS_SECRET_ACCESS_KEY = "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"
  AWS_DEFAULT_REGION = "us-east-1"
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
   }
 }
}
