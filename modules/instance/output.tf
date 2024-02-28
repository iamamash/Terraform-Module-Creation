# Output for Instance module
output "public_security_group_id" {
  value = aws_security_group.public_sg.id
}

output "private_security_group_id" {
  value = aws_security_group.private_sg.id
}

output "private_instance_id" {
  description = "Value of private instance id"
  value       = aws_instance.private_instance.*.id
}

output "public_instance_id" {
  description = "Value of public instance id"
  value       = aws_instance.public_instance.*.id
}
