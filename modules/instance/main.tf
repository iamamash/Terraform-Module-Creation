# Resources for Instance creation
# Module for VPC
module "VPC" {
  source              = "../vpc/"
  vpc_name            = "Zenskar-VPC"
  vpc_cidr            = "10.0.0.0/17"
  public_subnet_cidr  = "10.0.0.0/20"
  private_subnet_cidr = ["10.0.16.0/24","10.0.24.0/21"]
}

# Module for SSH Keypair
module "SSH_KEYPAIR" {
  source       = "../ssh-keypair/"
  key_name     = "zenskar-key"
  algorithm_name    = "RSA"
  keypair_bits = 4096
}

# Define security group for public instances
resource "aws_security_group" "public_sg" {
  vpc_id      = module.VPC.vpc_id
  name        = "public_sg"
  description = "Security group for public instances"

  # Define ingress rules for allowing inbound traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Define egress rules for allowing outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define security group for private instances
resource "aws_security_group" "private_sg" {
  vpc_id      = module.VPC.vpc_id
  name        = "private_sg"
  description = "Security group for private instances"

  ingress { 
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Define egress rules for allowing outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define public instance
resource "aws_instance" "public_instance" {
  count           = 1
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = module.VPC.public_subnet_id
  key_name        = module.SSH_KEYPAIR.aws_key_pairs
  security_groups = [aws_security_group.public_sg.id]
  tags = {
    Name : var.public_instance_name
  }
}

# Define private instances
resource "aws_instance" "private_instance" {
  count           = 2
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = module.VPC.private_subnet_id[count.index]
  key_name        = module.SSH_KEYPAIR.aws_key_pairs
  security_groups = [aws_security_group.private_sg.id]
  tags = {
    Name : "${element(var.private_instance_name, count.index)}"
  }
}
