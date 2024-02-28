# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw"
  }
}

# Create Route Table for Public Subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

# Associate Route Table with Public Subnet
resource "aws_route_table_association" "public_route_association" {
  subnet_id      = aws_subnet.public_subnet[0].id
  route_table_id = aws_route_table.public_route_table.id
}

# Allocate Elastic IP. (This EIP will be used for the Nat-Gateway in the Public Subnet)
resource "aws_eip" "eip_for_nat_gateway" {
  domain = "vpc"

  tags = {
    Name = "Nat_Gateway_EIP"
  }
}

# Create NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip_for_nat_gateway.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "nat_gateway"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

# Create Route Table for Private Subnet add route through Nat Gateway to access internet
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "private_route_table"
  }
}

# Associate Route Table with Private Subnet
resource "aws_route_table_association" "private_route_association" {
  subnet_id      = aws_subnet.private_subnet[0].id
  route_table_id = aws_route_table.private_route_table.id
}
