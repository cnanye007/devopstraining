# VPC Variables
variable "region" {
  default       = "us-east-1"
  description   = "AWS Region"
  type          = string
}

variable "project_name" {
  default = "terraform-vpc"
}

variable "vpc-cidr" {
  default       = "192.72.0.0/20"
  description   = "VPC CIDR Block"
  type          = string
}

variable "public-subnet-1-cidr" {
  default       = "192.72.1.32/27"
  description   = "Public Subnet 1 CIDR Block"
  type          = string
}

variable "public-subnet-2-cidr" {
  default       = "192.72.1.64/27"
  description   = "Public Subnet 2 CIDR Block"
  type          = string
}

variable "private-subnet-1-cidr" {
  default       = "192.72.1.96/27"
  description   = "Private Subnet 1 CIDR Block"
  type          = string
}

variable "private-subnet-2-cidr" {
  default       = "192.72.1.128/27"
  description   = "Private Subnet 2 CIDR Block"
  type          = string
}

variable "private-subnet-3-cidr" {
  default       = "192.72.1.160/27"
  description   = "Private Subnet 3 CIDR Block"
  type          = string
}

variable "private-subnet-4-cidr" {
  default       = "192.72.1.192/27"
  description   = "Private Subnet 4 CIDR Block"
  type          = string
}

variable "ssh_bastion_host_conn" {
  default       = "0.0.0.0/0"
  description   = "ssh access for prodction case limit to company ips"
  type          = string
}

# variable "rds_snapshot_identifier" {
#   default       = ""
#   description   = "rds db snapshot arn"
#   type          = string
# }

variable "rds_db_instance_class" {
  default       = "db.t2.micro"
  description   = "rds db instance type"
  type          = string
}

variable "rds_db_instance_identifier" {
  default       = "mysql57db" 
  description   = "rds db instance identifier"
  type          = string
}

variable "rds_multi_az_deployment" {
  default       = "false" ##or true to create standby db
  description   = "rds db deployment type"
  type          = bool  ##boolean ##this is becs the value is either true or false
}

