#VPC
resource "aws_vpc" "assignment_vpc" {
  cidr_block                = "10.0.0.0/16"
  enable_dns_support        = true
  enable_dns_hostnames      = true
  tags                      = merge(var.tags)
}

#public subnets
resource "aws_subnet" "public_subnet" {
  count = 3

  vpc_id                    = aws_vpc.assignment_vpc.id
  cidr_block                = element(["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"], count.index)
  availability_zone         = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch   = true
  tags                      = merge(var.tags, tomap({
                                "Name" = "public-subnet-${count.index + 1}"}))
  }

#private subnets
resource "aws_subnet" "private_subnet" {
  count = 3

  vpc_id                    = aws_vpc.assignment_vpc.id
  cidr_block                = element(["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"], count.index)
  availability_zone         = element(data.aws_availability_zones.available.names, count.index)
  tags                      = merge(var.tags, tomap({
                                "Name" = "private-subnet-${count.index + 1}"}))
  }

#internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id                    = aws_vpc.assignment_vpc.id
  tags                      = merge(var.tags)
}

#public route table
resource "aws_route_table" "public_route_table" {
  vpc_id                    = aws_vpc.assignment_vpc.id
  route {
    cidr_block              = "0.0.0.0/0"
    gateway_id              = aws_internet_gateway.igw.id
  }
  tags                      = merge(var.tags)
}

#private route table
resource "aws_route_table" "private_route_table" {
  vpc_id                    = aws_vpc.assignment_vpc.id
  tags                      = merge(var.tags)
}

#public route table association
resource "aws_route_table_association" "public_subnet_association" {
  count                     = 3
  subnet_id                 = aws_subnet.public_subnet[count.index].id
  route_table_id            = aws_route_table.public_route_table.id
}

#private route table association
resource "aws_route_table_association" "private_subnet_association" {
  count                     = 3
  subnet_id                 = aws_subnet.private_subnet[count.index].id
  route_table_id            = aws_route_table.private_route_table.id
}

data "aws_availability_zones" "available" {}

