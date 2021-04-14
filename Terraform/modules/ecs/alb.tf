# alb

resource "aws_lb" "backend" {
  name                             = "${var.environment}-backend"
  internal                         = false
  load_balancer_type               = "application"
  subnets                          = data.aws_subnet_ids.public_subnets.ids
  security_groups                  = [aws_security_group.lb_sg.id]
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = false

  tags = {
    Name = "${var.environment}-backend"
  }
}

resource "aws_lb_target_group" "backend" {
  depends_on  = [aws_lb.backend]
  name        = "${var.environment}-backend"
  target_type = "ip"
  protocol    = "HTTP"
  port        = 80
  vpc_id      = data.aws_vpc.current.id
  #slow_start  = 30

  health_check {
    path = var.lb_health_check_path
    unhealthy_threshold = 5
  }

  tags = {
    Name = "${var.environment}-backend-tg"
  }

  stickiness {
    type = "lb_cookie"
  }
}

resource "aws_lb_listener" "backend" {
  depends_on        = [aws_lb_target_group.backend]
  load_balancer_arn = aws_lb.backend.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
resource "aws_lb_listener" "backend-https" {
  depends_on        = [aws_lb_target_group.backend]
  load_balancer_arn = aws_lb.backend.arn
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.certificate_arn

  default_action {
    target_group_arn = aws_lb_target_group.backend.arn
    type             = "forward"
  }
}

