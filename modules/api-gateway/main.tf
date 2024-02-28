# Module for Load Balancer
module "LOAD_BALANCER" {
  source  = "../load-balancer/"
  lb_name = "alb"
  lb_type = "application"
}

# Create API Gateway
resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = var.api_gateway_name
  description = "API Gateway for ALB access"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Create API Gateway resource
resource "aws_api_gateway_resource" "api_gateway_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "nginx"
}

# Create API Gateway method
resource "aws_api_gateway_method" "api_gateway_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.api_gateway_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# Create API Gateway integration
resource "aws_api_gateway_integration" "api_gateway_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.api_gateway_resource.id
  http_method             = aws_api_gateway_method.api_gateway_method.http_method
  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = "http://${module.LOAD_BALANCER.elb-dns-name}/nginx"
}

# Create API Gateway deployment
resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  depends_on  = [aws_api_gateway_integration.api_gateway_integration]
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  stage_name  = "prod"
}
