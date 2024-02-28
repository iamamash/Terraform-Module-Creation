# Target group for the Application Load Balancer
resource "aws_lb_target_group" "target-group" {
  name        = "alb-tg"          # Name of the target group
  port        = 80                # Port for the target group
  protocol    = "HTTP"            # Protocol for the target group
  target_type = "instance"        # Target type for the target group
  vpc_id      = module.VPC.vpc_id # VPC ID for the target group

  # Health check for the target group
  health_check {
    enabled             = true
    interval            = 10
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Creating the Application Load Balancer
resource "aws_lb" "alb" {
  name               = var.lb_name # Name of the Application Load Balancer
  internal           = false
  load_balancer_type = var.lb_type # Type of the Application Load Balancer

  security_groups = [module.EC2_INSTANCE.private_security_group_id] # Security group for the Application Load Balancer 

  subnets = [module.VPC.private_subnet_id[0], module.VPC.private_subnet_id[1]] # Subnets for the Application Load Balancer
}

# Creating the listener for the Application Load Balancer
resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.alb.arn # ARN of the Application Load Balancer
  port              = 80
  protocol          = "HTTP"

  # Default action for the listener, which redirects all traffic to the default target group
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}

# Attach the EC2 instances to the Application Load Balancer
resource "aws_lb_target_group_attachment" "private_alb_attachment" {
  count            = length(module.EC2_INSTANCE.private_instance_id) # Number of instances to attach to the target group
  target_group_arn = aws_lb.alb.arn
  target_id        = module.EC2_INSTANCE.private_instance_id[count.index] # ID of the instance to attach to the target group
  port             = 80
}



# ----------------------------------------------------------------------------
# Module for VPC
module "VPC" {
  source              = "../vpc/"                        # Path to the VPC module directory
  vpc_name            = "Zenskar-VPC"                    # Name of the VPC
  vpc_cidr            = "10.0.0.0/17"                    # CIDR block for the VPC
  public_subnet_cidr  = "10.0.0.0/20"                    # CIDR block for the public subnet
  private_subnet_cidr = ["10.0.16.0/24", "10.0.24.0/21"] # List of CIDR block for the private subnet
}

# Module for EC2 Instance
module "EC2_INSTANCE" {
  source        = "../instance/"          # Path to the EC2 instance module directory
  ami           = "ami-0440d3b780d96b29d" # AMI for the EC2 instance
  instance_type = "t2.micro"              # Type of the EC2 instance
}

# Module for Load Balancer
module "LOAD_BALANCER" {
  source  = "./load-balancer/" # Path to the Load Balancer module directory
  lb_name = "alb"              # Name of the load balancer
  lb_type = "application"      # Type of the load balancer
}
