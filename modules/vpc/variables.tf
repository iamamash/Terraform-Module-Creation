# Variable for the VPC CIDR Block
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

# Variable for the Public Subnet CIDR Blocks
variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

# Variable for the Private Subnet CIDR Blocks
variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = list(string) # List of CIDR blocks for the private subnets. Must be at least two to create a NAT Gateway in the public subnet
}

# Variable for the VPC Name
variable "vpc_name" {
  description = "VPC name"
  type        = string
}

# Variable to define the list of availability zones for the region
variable "availability_zones" {
  description = "List of availability zones for the region"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"] # Default availability zones for us-east-1 region in AWS
}
