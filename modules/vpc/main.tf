# VPC resources
data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_subnet" {
  count             = 1
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.vpc_name}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = 2
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.vpc_name}-private-subnet-${count.index + 1}"
  }
}
