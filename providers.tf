# Variable for AWS region
variable "aws_region" {
  description = "Name for the AWS region"
  default     = "us-east-1"
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region # Reference to the AWS region
}
