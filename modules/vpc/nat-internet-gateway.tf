# Create the Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id # VPC ID

  tags = {
    Name = "igw" # Name of the Internet Gateway
  }
}

# Create Route Table for Public Subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id # VPC ID

  route {
    cidr_block = "0.0.0.0/0"                 # Route all traffic to the Internet Gateway
    gateway_id = aws_internet_gateway.igw.id # Internet Gateway ID
  }

  tags = {
    Name = "public_route_table" # Name of the Route Table
  }
}

# Associate Route Table with Public Subnet
resource "aws_route_table_association" "public_route_association" {
  subnet_id      = aws_subnet.public_subnet[0].id        # Public Subnet ID
  route_table_id = aws_route_table.public_route_table.id # Public Route Table ID
}

# Allocate Elastic IP. (This EIP will be used for the Nat-Gateway in the Public Subnet)
resource "aws_eip" "eip_for_nat_gateway" {
  domain = "vpc" # Domain for the EIP

  tags = {
    Name = "Nat_Gateway_EIP" # Name of the EIP for Nat Gateway
  }
}

# Create the NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip_for_nat_gateway.id # EIP ID
  subnet_id     = aws_subnet.public_subnet[0].id # Public Subnet ID

  tags = {
    Name = "nat_gateway" # Name of the NAT Gateway
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

# Create Route Table for Private Subnet add route through Nat Gateway to access internet
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"                    # Route all traffic to the NAT Gateway
    nat_gateway_id = aws_nat_gateway.nat_gateway.id # NAT Gateway ID
  }

  tags = {
    Name = "private_route_table" # Name of the Route Table
  }
}

# Associate Route Table with Private Subnet
resource "aws_route_table_association" "private_route_association" {
  subnet_id      = aws_subnet.private_subnet[0].id        # Private Subnet ID
  route_table_id = aws_route_table.private_route_table.id # Private Route Table ID
}
