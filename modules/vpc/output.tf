# Output the VPC ID of the created VPC
output "vpc_id" {
  value = aws_vpc.vpc.id
}

# Output the Public Subnet ID of the created Subnet
output "public_subnet_id" {
  value = aws_subnet.public_subnet[*].id
}

# Output the Private Subnet ID of the created Subnets
output "private_subnet_id" {
  value = aws_subnet.private_subnet[*].id # Output all the private subnet IDs
}
