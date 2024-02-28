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

  # Provisioner to install Ansible on the private instances
  provisioner "remote-exec" {
    # Connection details for the private instance
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("~/.ssh/id_rsa")}"
      host        = aws_instance.private_instance[count.index].public_ip
    }

    # Commands to install Ansible on the private instance
    inline = [
      "sudo apt update -y",
      "sudo apt install software-properties-common -y",
      "sudo add-apt-repository --yes --update ppa:ansible/ansible -y",
      "sudo apt install ansible -y"
    ]
  }

  # Passing Elastic IP as an argument to the Ansible playbook
  provisioner "local-exec" {
    command = "ansible-playbook -e 'elastic_ip_1=${aws_eip.eip[0].public_ip},elastic_ip_2=${aws_eip.eip[1].public_ip}' ../../ansible/playbook.yml" # Command to execute the Ansible playbook

    working_dir = "../../ansible/" # Working directory for the Ansible playbook                         
  }

  tags = {
    Name : "${element(var.private_instance_name, count.index)}" # Name of the instance
  }
}

# Create an Elastic IP
resource "aws_eip" "eip" {
  count    = 2                                             # Create two Elastic IPs
  instance = aws_instance.private_instance[count.index].id # Reference to the private instance
}

# Associate the Elastic IP with the EC2 instance
resource "aws_eip_association" "eip_association" {
  count         = 2                                             # Associate two Elastic IPs
  instance_id   = aws_instance.private_instance[count.index].id # Reference to the private instance
  allocation_id = aws_eip.eip[count.index].id                   # Reference to the Elastic IP
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
