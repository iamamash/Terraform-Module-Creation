# Output the DNS name of the load balancer
output "elb-dns-name" {
  value = aws_lb.alb.dns_name
}
