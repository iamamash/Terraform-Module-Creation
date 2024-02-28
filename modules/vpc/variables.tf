# VPC variables
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = list(string)
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
}

# Define the list of availability zones for the region
variable "availability_zones" {
  description = "List of availability zones for the region"
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
