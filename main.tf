# Create VPC
# terraform aws create vpc
resource "aws_vpc" "vpc_priv" {
  cidr_block              = "${var.vpc-cidr}"
  instance_tenancy        = "default"
  enable_dns_hostnames    =  true

  tags      = {
    Name    = "${var.project_name}-vpc"
  }
}

##user data option to locate all AZs in the region u want to provision the vpc
#data "aws_availability_zones" "availability_zones" {}

#to reference this use below option in az field
  #data.aws_availability_zones.availability_zones.names[0]  #0 stands for indexing to select first az if 1 u want to select second az

# Create Internet Gateway and Attach it to VPC
# terraform aws create internet gateway
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id    = aws_vpc.vpc_priv.id

  tags      = {
    Name    = "priv_netwrk_ngw"
  }
}

# Create Public Subnet 1
# terraform aws create subnet
resource "aws_subnet" "public-subnet-web-1" {
  vpc_id                  = aws_vpc.vpc_priv.id
  cidr_block              = "${var.public-subnet-1-cidr}"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags      = {
    Name    = "Pub_subnet1|web"
  }
}

# Create Public Subnet 2
# terraform aws create subnet
resource "aws_subnet" "public-subnet-web-2" {
  vpc_id                  = aws_vpc.vpc_priv.id
  cidr_block              = "${var.public-subnet-2-cidr}"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags      = {
    Name    = "Pub_subnet2|web"
  }
}

# Create Route Table and Add Public Route
# terraform aws create route table
resource "aws_route_table" "public-route-table" {
  vpc_id       = aws_vpc.vpc_priv.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags       = {
    Name     = "Pub_rtb"
  }
}

# Associate Public Subnet 1 to "Public Route Table"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "public-subnet-1-route-table-association" {
  subnet_id           = aws_subnet.public-subnet-web-1.id
  route_table_id      = aws_route_table.public-route-table.id
}

# Associate Public Subnet 2 to "Public Route Table"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "public-subnet-2-route-table-association" {
  subnet_id           = aws_subnet.public-subnet-web-2.id
  route_table_id      = aws_route_table.public-route-table.id
}

# Create Private Subnet 1
# terraform aws create subnet
resource "aws_subnet" "private-subnet-apps-1" {
  vpc_id                   = aws_vpc.vpc_priv.id
  cidr_block               = "${var.private-subnet-1-cidr}"
  availability_zone        = "us-east-1a"
  map_public_ip_on_launch  = false ##this is private subnet and as such don't need public ip association

  tags      = {
    Name    = "Priv_subnet1|apps"
  }
}

# Create Private Subnet 2
# terraform aws create subnet
resource "aws_subnet" "private-subnet-db-2" {
  vpc_id                   = aws_vpc.vpc_priv.id
  cidr_block               = "${var.private-subnet-2-cidr}"
  availability_zone        = "us-east-1b"
  map_public_ip_on_launch  = false ##this is private subnet and as such don't need public ip association

  tags      = {
    Name    = "Priv_subnet2|db"
  }
}

# Create Private Subnet 3
# terraform aws create subnet
resource "aws_subnet" "private-subnet-apps-3" {
  vpc_id                   = aws_vpc.vpc_priv.id
  cidr_block               = "${var.private-subnet-3-cidr}"
  availability_zone        = "us-east-1a"
  map_public_ip_on_launch  = false ##this is private subnet and as such don't need public ip association

  tags      = {
    Name    = "Priv_subnet3|apps"
  }
}

# Create Private Subnet 4
# terraform aws create subnet
resource "aws_subnet" "private-subnet-db-4" {
  vpc_id                   = aws_vpc.vpc_priv.id
  cidr_block               = "${var.private-subnet-4-cidr}"
  availability_zone        = "us-east-1b"
  map_public_ip_on_launch  = false ##this is private subnet and as such don't need public ip association

  tags      = {
    Name    = "Priv_subnet4|db"
  }
}

###private subnet settings
# Allocate Elastic IP Address (EIP 1)
# terraform aws allocate elastic ip
resource "aws_eip" "eip-for-nat-gateway-1" {
  vpc    = true ##needed when creating eip

  tags   = {
    Name = "eip_nat_gw_1"
  }
}

# Allocate Elastic IP Address (EIP 2)
# terraform aws allocate elastic ip
resource "aws_eip" "eip-for-nat-gateway-2" {
  vpc    = true ##needed when creating eip

  tags   = {
    Name = "eip_nat_gw_2"
  }
}

# Create Nat Gateway 1 in Public Subnet 1
# terraform create aws nat gateway
resource "aws_nat_gateway" "nat-gateway-1" {
  allocation_id = aws_eip.eip-for-nat-gateway-1.id
  subnet_id     = aws_subnet.public-subnet-web-1.id

  tags   = {
    Name = "nat-gw-pub1"
  }
}

# Create Nat Gateway 2 in Public Subnet 2
# terraform create aws nat gateway
resource "aws_nat_gateway" "nat-gateway-2" {
  allocation_id = aws_eip.eip-for-nat-gateway-2.id
  subnet_id     = aws_subnet.public-subnet-web-2.id

  tags   = {
    Name = "nat-gw-pub2"
  }
}

# Create Private Route Table 1 and Add Route Through Nat Gateway 1
# terraform aws create route table
resource "aws_route_table" "private-route-table-1" {
  vpc_id            = aws_vpc.vpc_priv.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat-gateway-1.id
  }

  tags   = {
    Name = "Priv_rtb_1"
  }
}

# Associate Private Subnet 1 with "Private Route Table 1"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "private-subnet-1-route-table-association" {
  subnet_id         = aws_subnet.private-subnet-apps-1.id
  route_table_id    = aws_route_table.private-route-table-1.id
}

# Associate Private Subnet 3 with "Private Route Table 1"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "private-subnet-3-route-table-association" {
  subnet_id         = aws_subnet.private-subnet-db-2.id
  route_table_id    = aws_route_table.private-route-table-1.id
}

# Create Private Route Table 2 and Add Route Through Nat Gateway 2
# terraform aws create route table
resource "aws_route_table" "private-route-table-2" {
  vpc_id            = aws_vpc.vpc_priv.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  =  aws_nat_gateway.nat-gateway-2.id
  }

  tags   = {
    Name = "Priv_rtb_2"
  }
}

# Associate Private Subnet 2 with "Private Route Table 2"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "private-subnet-2-route-table-association" {
  subnet_id         = aws_subnet.private-subnet-apps-3.id
  route_table_id    = aws_route_table.private-route-table-2.id
}

# Associate Private Subnet 4 with "Private Route Table 2"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "private-subnet-4-route-table-association" {
  subnet_id         = aws_subnet.private-subnet-db-4.id
  route_table_id    = aws_route_table.private-route-table-2.id
}


# ###private subnet settings
# # Allocate Elastic IP Address (EIP 1)
# # terraform aws allocate elastic ip
# resource "aws_eip" "eip-for-nat-gateway-1" {
#   vpc    = true ##needed when creating eip

#   tags   = {
#     Name = "eip_nat_gw_1"
#   }
# }

# # Allocate Elastic IP Address (EIP 2)
# # terraform aws allocate elastic ip
# resource "aws_eip" "eip-for-nat-gateway-2" {
#   vpc    = true ##needed when creating eip

#   tags   = {
#     Name = "eip_nat_gw_2"
#   }
# }

# # Create Nat Gateway 1 in Public Subnet 1
# # terraform create aws nat gateway
# resource "aws_nat_gateway" "nat-gateway-1" {
#   allocation_id = aws_eip.eip-for-nat-gateway-1.id
#   subnet_id     = aws_subnet.public-subnet-1.id

#   tags   = {
#     Name = "nat-gw-pub1"
#   }
# }

# # Create Nat Gateway 2 in Public Subnet 2
# # terraform create aws nat gateway
# resource "aws_nat_gateway" "nat-gateway-2" {
#   allocation_id = aws_eip.eip-for-nat-gateway-2.id
#   subnet_id     = aws_subnet.public-subnet-2.id

#   tags   = {
#     Name = "nat-gw-pub2"
#   }
# }

# # Create Private Route Table 1 and Add Route Through Nat Gateway 1
# # terraform aws create route table
# resource "aws_route_table" "private-route-table-1" {
#   vpc_id            = aws_vpc.vpc_priv.id

#   route {
#     cidr_block      = "0.0.0.0/0"
#     nat_gateway_id  = aws_nat_gateway.nat-gateway-1.id
#   }

#   tags   = {
#     Name = "Priv_rtb_1"
#   }
# }

# # Associate Private Subnet 1 with "Private Route Table 1"
# # terraform aws associate subnet with route table
# resource "aws_route_table_association" "private-subnet-1-route-table-association" {
#   subnet_id         = aws_subnet.private-subnet-1.id
#   route_table_id    = aws_route_table.private-route-table-1.id
# }

# # Associate Private Subnet 3 with "Private Route Table 1"
# # terraform aws associate subnet with route table
# resource "aws_route_table_association" "private-subnet-3-route-table-association" {
#   subnet_id         = aws_subnet.private-subnet-3.id
#   route_table_id    = aws_route_table.private-route-table-1.id
# }

# # Create Private Route Table 2 and Add Route Through Nat Gateway 2
# # terraform aws create route table
# resource "aws_route_table" "private-route-table-2" {
#   vpc_id            = aws_vpc.vpc_priv.id

#   route {
#     cidr_block      = "0.0.0.0/0"
#     nat_gateway_id  =  aws_nat_gateway.nat-gateway-2.id
#   }

#   tags   = {
#     Name = "Priv_rtb_2"
#   }
# }

# # Associate Private Subnet 2 with "Private Route Table 2"
# # terraform aws associate subnet with route table
# resource "aws_route_table_association" "private-subnet-2-route-table-association" {
#   subnet_id         = aws_subnet.private-subnet-2.id
#   route_table_id    = aws_route_table.private-route-table-2.id
# }

# # Associate Private Subnet 4 with "Private Route Table 2"
# # terraform aws associate subnet with route table
# resource "aws_route_table_association" "private-subnet-4-route-table-association" {
#   subnet_id         = aws_subnet.private-subnet-4.id
#   route_table_id    = aws_route_table.private-route-table-2.id
# }

