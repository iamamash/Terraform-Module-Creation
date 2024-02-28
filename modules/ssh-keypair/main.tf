# Resources for creating the private key pair
resource "tls_private_key" "ssh_keypair" {
  algorithm = var.algorithm_name # Algorithm for the key pair
  rsa_bits  = var.keypair_bits   # Number of bits for the key pair
}

# Resource for creating the public key pair
resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name                                   # Name of the key pair
  public_key = tls_private_key.ssh_keypair.public_key_openssh # Public key for the key pair

  tags = {
    Name = var.key_name # Tag for the key pair
  }
}
