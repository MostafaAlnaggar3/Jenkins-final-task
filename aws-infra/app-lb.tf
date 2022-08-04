# create a target group for application load balancer
resource "aws_lb_target_group" "terraform-app-lb-tg" {
  name     = "terraform-app-lb-tg"
  port     = "3000"
  protocol = "HTTP"
  vpc_id   = module.Network.vpc_id
}

#target group attachment
resource "aws_lb_target_group_attachment" "terraform-app-tg-attach" {
  target_group_arn = aws_lb_target_group.terraform-app-lb-tg.arn
  target_id        = aws_instance.terra-app.id
  port             = "3000"
}

# create an application load balancer
resource "aws_lb" "terraform-app-lb" {
  name                       = "terraform-app-lb"
  internal                   = false
  security_groups            = [aws_security_group.sg-1.id]
  subnets                    = [module.Network.public_subnet_1_id, module.Network.public_subnet_2_id]
  ip_address_type            = "ipv4"
  enable_deletion_protection = false
}

# to attach tg to lb
resource "aws_alb_listener" "app-lb-listener" {  
  load_balancer_arn =  aws_lb.terraform-app-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {    
    target_group_arn = aws_lb_target_group.terraform-app-lb-tg.arn
    type             = "forward"  
  }
}