# Variables for the EC2 instances
variable "ami" {
  description = "AMI for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
}

variable "public_instance_name" {
  description = "EC2 Instance name"
  default     = "Zenskar's-public-instance"
}

variable "private_instance_name" {
  description = "EC2 Instance name"
  default     = ["Zenskar's-private-instance-1", "Zenskar's-private-instance-2"]
}
