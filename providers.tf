# Configure the AWS Provider
variable "aws_region" {
  description = "Name for the AWS region"
  default     = "us-east-1"
}

provider "aws" {
  region = var.aws_region
}
