# Output the security group id of public instance
output "public_security_group_id" {
  value = aws_security_group.public_sg.id
}

# Output the security group id of private instance
output "private_security_group_id" {
  value = aws_security_group.private_sg.id
}

# Output the instance id of private instance
output "private_instance_id" {
  description = "Value of private instance id"
  value       = aws_instance.private_instance[*].id
}

# Output the instance id of public instance
output "public_instance_id" {
  description = "Value of public instance id"
  value       = aws_instance.public_instance[*].id
}

# Output the Elastic IP
output "elastic_ip" {
  value = aws_eip.eip.public_ip
}
