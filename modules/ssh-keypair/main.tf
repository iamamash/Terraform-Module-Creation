# Resources for creating the SSH keypair
resource "tls_private_key" "ssh_keypair" {
  algorithm = var.algorithm_name
  rsa_bits  = var.keypair_bits
} 

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh_keypair.public_key_openssh

  tags = {
    Name = var.key_name
  }
}