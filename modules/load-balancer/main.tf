# Target group for the Application Load Balancer
# Module for VPC
module "VPC" {
  source              = "../vpc/"
  vpc_name            = "Zenskar-VPC"
  vpc_cidr            = "10.0.0.0/17"
  public_subnet_cidr  = "10.0.0.0/20"
  private_subnet_cidr = ["10.0.16.0/24","10.0.24.0/21"]
}

# Module for EC2 Instance
module "EC2_INSTANCE" {
  source        = "../instance/"
  ami           = "ami-0440d3b780d96b29d"
  instance_type = "t2.micro"
}


resource "aws_lb_target_group" "target-group" {
  name        = "alb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = module.VPC.vpc_id

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
  name               = var.lb_name
  internal           = false
  load_balancer_type = var.lb_type
  security_groups    = [module.EC2_INSTANCE.private_security_group_id]
  subnets            = [module.VPC.private_subnet_id[0], module.VPC.private_subnet_id[1]]
}

resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}

# Attach the EC2 instances to the Application Load Balancer
resource "aws_lb_target_group_attachment" "private_alb_attachment" {
  count            = length(module.EC2_INSTANCE.private_instance_id)
  target_group_arn = aws_lb.alb.arn
  target_id        = module.EC2_INSTANCE.private_instance_id[count.index]
  port             = 80
}
