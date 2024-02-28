# Variables for the instance ami value
variable "ami" {
  description = "AMI for the EC2 instances"
  type        = string
}

# Variables for the instance type
variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
}

# Variables for the public instance name
variable "public_instance_name" {
  description = "EC2 Instance name"
  default     = "Zenskar's-public-instance"
}

# Variables for the private instance name
variable "private_instance_name" {
  description = "EC2 Instance name"
  default     = ["Zenskar's-private-instance-1", "Zenskar's-private-instance-2"] # List of private instance names
}
