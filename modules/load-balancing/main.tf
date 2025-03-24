resource "aws_lb" "wp-alb" {
  name               = "wp-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_groups]
  subnets            = var.subnets
  tags = {
    Environment = "${terraform.workspace}"
  }
}

resource "aws_lb_target_group" "wp-alb-tg" {
  name     = "wp-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  stickiness {
    type            = "lb_cookie" # Cookie-based stickiness (ALB-managed)
    cookie_duration = 86400       # Stickiness duration (in seconds)
  }

  health_check {
    path                = "/"   # The endpoint to check (Change if needed)
    interval            = 30    # Health check interval (seconds)
    timeout             = 5     # Timeout for each check
    healthy_threshold   = 3     # Number of successes before marking healthy
    unhealthy_threshold = 3     # Number of failures before marking unhealthy
    matcher             = "200" # Expected HTTP response code (200 OK)
  }
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.wp-alb-tg.arn
  count            = length(var.target_ids) # Problem facing for the for_each solved by the count , for_each required the known value of the set length
  target_id        = var.target_ids[count.index]
  port             = 80
}

resource "aws_lb_listener" "wp-alb-listener" {
  load_balancer_arn = aws_lb.wp-alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wp-alb-tg.arn
  }
}