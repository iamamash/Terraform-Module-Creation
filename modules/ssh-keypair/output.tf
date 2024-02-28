# Output the public key
output "public_key" {
  description = "The public key for the SSH keypair"
  value       = tls_private_key.ssh_keypair.public_key_openssh
}

# Output the private key in PEM format
output "private_key" {
  description = "The private key for the SSH keypair"
  value       = tls_private_key.ssh_keypair.private_key_pem
}

# Output the key pair name
output "aws_key_pairs" {
  description = "The AWS key pair"
  value       = aws_key_pair.generated_key.key_name
}
