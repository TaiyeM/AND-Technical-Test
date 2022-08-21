# Configure the AWS Provider
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "AND_VPC" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "AND_VPC"
  }

}

resource "aws_subnet" "AND_public_subnet" {
  vpc_id     = aws_vpc.AND_VPC.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "AND_public_subnet"
  }

}
resource "aws_internet_gateway" "AND_gw" {
  vpc_id = aws_vpc.AND_VPC.id

  tags = {
    Name = "AND_gw"
  }
}

resource "aws_route_table" "AND_route_table" {
  vpc_id = aws_vpc.AND_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.AND_gw.id
  }
  
  tags = {
    Name = "AND_route_table"
  }
}

resource "aws_route_table_association" "AND_public_subnet_association" {
  subnet_id      = aws_subnet.AND_public_subnet.id
  route_table_id = aws_route_table.AND_route_table.id
}
  


