provider "aws" {
  region = "us-east-1"
  profile = "default"
  shared_config_files = ["/home/ec2-user/.aws/config"]
  shared_credentials_files = ["/home/ec2-user/.aws/credentials"]
}

