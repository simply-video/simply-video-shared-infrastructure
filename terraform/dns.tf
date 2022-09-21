### routre 53 
data "aws_route53_zone" "current" {
  name         = "${var.domain}."
  private_zone = false
}

resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.current.zone_id
  name    = "api"
  type    = "A"

  alias {
    name                   = aws_lb.alb-main.dns_name
    zone_id                = aws_lb.alb-main.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "chat" {
  zone_id = data.aws_route53_zone.current.zone_id
  name    = "chat"
  type    = "A"

  alias {
    name                   = aws_lb.alb-main.dns_name
    zone_id                = aws_lb.alb-main.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "frontend" {
  zone_id = data.aws_route53_zone.current.zone_id
  name    = ""
  type    = "A"

  alias {
    name                   = aws_lb.alb-main.dns_name
    zone_id                = aws_lb.alb-main.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "provision_portal" {
  zone_id = data.aws_route53_zone.current.zone_id
  name    = "portal"
  type    = "A"

  alias {
    name                   = aws_lb.alb-main.dns_name
    zone_id                = aws_lb.alb-main.zone_id
    evaluate_target_health = true
  }
}