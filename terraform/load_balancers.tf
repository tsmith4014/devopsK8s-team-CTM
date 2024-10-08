### load_balancers.tf

# load_balancers.tf
resource "aws_lb" "shredder_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.shredder_eks_sg.id]
  subnets            = [aws_subnet.shredder_subnet_public_1.id,
                        aws_subnet.shredder_subnet_public_2.id]
}

resource "aws_lb_target_group" "backend_target_group" {
  name        = var.target_group_name
  port        = var.target_group_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.shredder_vpc.id
  target_type = "ip"
}

resource "aws_lb_listener" "shredder_listener" {
  load_balancer_arn = aws_lb.shredder_alb.arn
  port              = var.listener_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_target_group.arn
  }
}

