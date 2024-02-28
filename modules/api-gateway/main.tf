# Create the API Gateway
resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = var.api_gateway_name # Name of the API Gateway
  description = "API Gateway for ALB access"

  # Configuration block for the API Gateway
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Create API Gateway resource
resource "aws_api_gateway_resource" "api_gateway_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id               # Reference to the API Gateway
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id # Reference to the root resource
  path_part   = "nginx"                                               # Path for the resource
}

# Create API Gateway method
resource "aws_api_gateway_method" "api_gateway_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.api_gateway_resource.id # Reference to the API Gateway resource
  http_method   = "GET"                                            # HTTP method for the API Gateway
  authorization = "NONE"                                           # Authorization type for the API Gateway
}

# Create API Gateway integration
resource "aws_api_gateway_integration" "api_gateway_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.api_gateway_resource.id
  http_method             = aws_api_gateway_method.api_gateway_method.http_method # Reference to the API Gateway method
  integration_http_method = "GET"                                                 # HTTP method for the integration
  type                    = "HTTP_PROXY"                                          # Type of the integration
  uri                     = "http://${module.LOAD_BALANCER.elb-dns-name}/nginx"   # URI for the integration
}

# Create API Gateway deployment
resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  depends_on  = [aws_api_gateway_integration.api_gateway_integration] # Depend on the API Gateway integration
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  stage_name  = "prod" # Stage name for the deployment
}



# ----------------------------------------------------------------------------
# Module for API Gateway
module "API_GATEWAY" {
  source           = "./api-gateway/" # Path to the API Gateway module directory
  api_gateway_name = "api-gateway"    # Name of the API Gateway
}
