# Output API Gateway URL
output "api_gateway_url" {
  value = aws_api_gateway_deployment.api_gateway_deployment.invoke_url # Reference to the API Gateway deployment
}
