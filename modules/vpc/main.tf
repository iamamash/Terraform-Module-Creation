# This will be used to access all the available zones in the region
data "aws_availability_zones" "available" {}

# Resource for VPC creation
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr # CIDR block for the VPC
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = var.vpc_name # Name of the VPC
  }
}

# Resource for Public Subnet creation
resource "aws_subnet" "public_subnet" {
  count             = 1 # Create only one public subnet
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidr                       # CIDR block for the public subnet
  availability_zone = element(var.availability_zones, count.index) # Availability zone for the public subnet

  tags = {
    Name = "${var.vpc_name}-public-subnet-${count.index + 1}" # Name of the public subnet
  }
}

# Resource for Private Subnet creation
resource "aws_subnet" "private_subnet" {
  count             = 2 # Creates two private subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr[count.index]         # CIDR block for the private subnet
  availability_zone = element(var.availability_zones, count.index) # Availability zone for the private subnet

  tags = {
    Name = "${var.vpc_name}-private-subnet-${count.index + 1}" # Name of the private subnet
  }
}
