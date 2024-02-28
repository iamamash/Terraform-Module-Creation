# Resource to define security group for public instances
resource "aws_security_group" "public_sg" {
  vpc_id      = module.VPC.vpc_id # Reference to the VPC module
  name        = "public_sg"
  description = "Security group for public instances"

  # Define ingress rules for allowing inbound traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH access from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP access from anywhere
  }

  # Define egress rules for allowing outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all traffic to anywhere
  }
}

# Define security group for private instances
resource "aws_security_group" "private_sg" {
  vpc_id      = module.VPC.vpc_id # Reference to the VPC module
  name        = "private_sg"
  description = "Security group for private instances"

  # Define ingress rules for allowing inbound traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH access from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP access from anywhere
  }

  # Define egress rules for allowing outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all traffic to anywhere
  }
}

# Define public instance
resource "aws_instance" "public_instance" {
  count           = 1                                 # Create only one instance
  ami             = var.ami                           # AMI ID for the instance
  instance_type   = var.instance_type                 # Instance type for the instance
  subnet_id       = module.VPC.public_subnet_id       # Reference to the VPC module
  key_name        = module.SSH_KEYPAIR.aws_key_pairs  # Reference to the SSH Keypair module
  security_groups = [aws_security_group.public_sg.id] # Reference to the security group for public instances
  tags = {
    Name : var.public_instance_name # Name of the instance
  }
}

# Define private instances
resource "aws_instance" "private_instance" {
  count           = 2                                         # Create two instances
  ami             = var.ami                                   # AMI ID for the instance
  instance_type   = var.instance_type                         # Instance type for the instance
  subnet_id       = module.VPC.private_subnet_id[count.index] # Reference to the VPC module
  key_name        = module.SSH_KEYPAIR.aws_key_pairs          # Reference to the SSH Keypair module
  security_groups = [aws_security_group.private_sg.id]        # Reference to the security group for private instances
  tags = {
    Name : "${element(var.private_instance_name, count.index)}" # Name of the instance
  }
}



# ----------------------------------------------------------------------------
# Module for VPC
module "VPC" {
  source              = "../vpc/"                        # Path to the VPC module directory
  vpc_name            = "Zenskar-VPC"                    # Name of the VPC
  vpc_cidr            = "10.0.0.0/17"                    # CIDR block for the VPC
  public_subnet_cidr  = "10.0.0.0/20"                    # CIDR block for the public subnet
  private_subnet_cidr = ["10.0.16.0/24", "10.0.24.0/21"] # List of CIDR block for the private subnet
}


# Module for SSH Keypair
module "SSH_KEYPAIR" {
  source         = "../ssh-keypair/" # Path to the SSH Keypair module directory
  key_name       = "zenskar-key"     # Name of the SSH Keypair
  algorithm_name = "RSA"             # Algorithm name for the SSH Keypair
  keypair_bits   = 4096              # Number of bits for the SSH Keypair
}
