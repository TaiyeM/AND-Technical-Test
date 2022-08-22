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
    description = "The VPC for the webserver"
  }

}
# Used in Line 23 in main.tf
data "aws_availability_zones" "Zones" {
  
}
resource "aws_subnet" "AND_public_subnets" {
  vpc_id     = aws_vpc.AND_VPC.id
  cidr_block = element(var.AND_public_subnets_cidr, count.index)
  map_public_ip_on_launch = true
  count = 2
  availability_zone = data.aws_availability_zones.Zones.names[count.index]
  

  tags = {
    Name = "AND_public_subnet"
    description = "The VPC Public Subnet"
  }

}
resource "aws_internet_gateway" "AND_gw" {
  vpc_id = aws_vpc.AND_VPC.id

  tags = {
    Name = "AND_gw"
    description = "The VPC Internet Gateway"
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
    description = "The VPC Route Table"
  }
}

resource "aws_route_table_association" "AND_public_subnet_association" {
  count = 2
  subnet_id      = element(aws_subnet.AND_public_subnets.*.id, count.index)
  route_table_id = aws_route_table.AND_route_table.id
}
  


