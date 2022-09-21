resource "aws_lb" "alb-main" {
  name               = "${var.env}-${var.project}-alb"
  subnets            = aws_subnet.sub-pub-main[*].id
  security_groups    = [aws_security_group.sg-pub-lb.id]
  internal           = false
  enable_http2       = true
  load_balancer_type = "application"

  tags = {
    Name = "${var.env}-${var.project}-alb"
  }
}

#### .http listener
resource "aws_lb_listener" "alb-listener-http-main" {
  load_balancer_arn = aws_lb.alb-main.arn
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

#### .https listener
resource "aws_lb_listener" "alb-listener-https-main" {
  load_balancer_arn = aws_lb.alb-main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
  certificate_arn   = var.lb_listener_https_certificate_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not found"
      status_code  = "404"
    }
  }
}

#### target groups
resource "aws_lb_target_group" "alb-tg-api" {
  name        = "${var.env}-${var.project}-api"
  protocol    = "HTTP"
  port        = 80
  vpc_id      = aws_vpc.vpc-main.id
  target_type = "ip"

  health_check {
    port                = "traffic-port"
    path                = "/"
    protocol            = "HTTP"
    timeout             = 10
    matcher             = "200"
    interval            = 30
    unhealthy_threshold = 2
    healthy_threshold   = 5
  }

  lifecycle {
    create_before_destroy = "true"
  }

  tags = {
    Name = "${var.env}-${var.project}-api"
  }
}

resource "aws_lb_target_group" "alb-tg-chat" {
  name        = "${var.env}-${var.project}-chat"
  protocol    = "HTTP"
  port        = 80
  vpc_id      = aws_vpc.vpc-main.id
  target_type = "ip"

  health_check {
    port                = "traffic-port"
    path                = "/"
    protocol            = "HTTP"
    timeout             = 10
    matcher             = "200"
    interval            = 30
    unhealthy_threshold = 2
    healthy_threshold   = 5
  }

  lifecycle {
    create_before_destroy = "true"
  }

  tags = {
    Name = "${var.env}-${var.project}-chat"
  }
}

resource "aws_lb_target_group" "alb-tg-frontend" {
  name        = "${var.env}-${var.project}-frontend"
  protocol    = "HTTP"
  port        = 80
  vpc_id      = aws_vpc.vpc-main.id
  target_type = "ip"

  health_check {
    port                = "traffic-port"
    path                = "/"
    protocol            = "HTTP"
    timeout             = 10
    matcher             = "200"
    interval            = 30
    unhealthy_threshold = 2
    healthy_threshold   = 5
  }

  lifecycle {
    create_before_destroy = "true"
  }

  tags = {
    Name = "${var.env}-${var.project}-frontend"
  }
}

resource "aws_lb_target_group" "alb-tg-provision_portal" {
  name        = "${var.env}-${var.project}-provision-port"
  protocol    = "HTTP"
  port        = 80
  vpc_id      = aws_vpc.vpc-main.id
  target_type = "ip"

  health_check {
    port                = "traffic-port"
    path                = "/"
    protocol            = "HTTP"
    timeout             = 10
    matcher             = "200"
    interval            = 30
    unhealthy_threshold = 2
    healthy_threshold   = 5
  }

  lifecycle {
    create_before_destroy = "true"
  }

  tags = {
    Name = "${var.env}-${var.project}-frontend"
  }
}


#### alb rules
resource "aws_lb_listener_rule" "alb-lrule-api" {
  listener_arn = aws_lb_listener.alb-listener-https-main.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg-api.arn
  }

  condition {
    host_header {
      values = ["api.${var.domain}"]
    }
  }
}

resource "aws_lb_listener_rule" "alb-lrule-chat" {
  listener_arn = aws_lb_listener.alb-listener-https-main.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg-chat.arn
  }

  condition {
    host_header {
      values = ["chat.${var.domain}"]
    }
  }
}

resource "aws_lb_listener_rule" "alb-lrule-frontend" {
  listener_arn = aws_lb_listener.alb-listener-https-main.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg-frontend.arn
  }

  condition {
    host_header {
      values = ["${var.domain}"]
    }
  }
}

resource "aws_lb_listener_rule" "alb-lrule-provision_portal" {
  listener_arn = aws_lb_listener.alb-listener-https-main.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg-provision_portal.arn
  }

  condition {
    host_header {
      values = ["portal.${var.domain}"]
    }
  }
}