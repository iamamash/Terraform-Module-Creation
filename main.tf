# Module for API Gateway
module "API_GATEWAY" {
  source           = "./modules/api-gateway/"
  api_gateway_name = "api-gateway"
}