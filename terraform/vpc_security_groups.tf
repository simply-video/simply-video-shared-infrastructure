### security groups

resource "aws_security_group" "sg-pub-lb" {
  name        = "${var.env}-${var.project}-pub-lb-sg"
  description = "${var.env}-${var.project}-pub-lb-sg"
  vpc_id      = aws_vpc.vpc-main.id

  tags = {
    Name = "${var.env}-${var.project}-pub-lb-sg"

  }
}

resource "aws_security_group" "sg-http-outbound" {
  name        = "${var.env}-${var.project}-http-outbound-sg"
  description = "${var.env}-${var.project}-http-outbound-sg"
  vpc_id      = aws_vpc.vpc-main.id

  tags = {
    Name = "${var.env}-${var.project}-http-outbound-sg"

  }
}

resource "aws_security_group" "sg-ses-outbound" {
  name        = "${var.env}-${var.project}-ses-outbound-sg"
  description = "${var.env}-${var.project}-ses-outbound-sg"
  vpc_id      = aws_vpc.vpc-main.id

  tags = {
    Name = "${var.env}-${var.project}-ses-outbound-sg"

  }
}

resource "aws_security_group" "sg-pub-bastion" {
  name        = "${var.env}-${var.project}-pub-bastion-sg"
  description = "${var.env}-${var.project}-pub-bastion-sg"
  vpc_id      = aws_vpc.vpc-main.id

  tags = {
    Name = "${var.env}-${var.project}-pub-bastion-sg"

  }
}

resource "aws_security_group" "sg-app" {
  name        = "${var.env}-${var.project}-app-sg"
  description = "${var.env}-${var.project}-app-sg"
  vpc_id      = aws_vpc.vpc-main.id

  tags = {
    Name = "${var.env}-${var.project}-app-sg"

  }
}

resource "aws_security_group" "sg-chat" {
  name        = "${var.env}-${var.project}-chat-sg"
  description = "${var.env}-${var.project}-chat-sg"
  vpc_id      = aws_vpc.vpc-main.id

  tags = {
    Name = "${var.env}-${var.project}-chat-sg"

  }
}

resource "aws_security_group" "sg-db-aurora" {
  name        = "${var.env}-${var.project}-db-aurora-sg"
  description = "${var.env}-${var.project}-db-aurora-sg"
  vpc_id      = aws_vpc.vpc-main.id

  tags = {
    Name = "${var.env}-${var.project}-db-aurora-sg"

  }
}

resource "aws_security_group" "sg-cache-redis" {
  name        = "${var.env}-${var.project}-cache-redis-sg"
  description = "${var.env}-${var.project}-cache-redis-sg"
  vpc_id      = aws_vpc.vpc-main.id

  tags = {
    Name = "${var.env}-${var.project}-cache-redis-sg"

  }
}

resource "aws_security_group" "sg-frontend" {
  name        = "${var.env}-${var.project}-frontend-sg"
  description = "${var.env}-${var.project}-frontend-sg"
  vpc_id      = aws_vpc.vpc-main.id
  tags = {
    Name = "${var.env}-${var.project}-frontend-sg"
  }
}
resource "aws_security_group" "sg-portal" {
  name        = "${var.env}-${var.project}-portal-sg"
  description = "${var.env}-${var.project}-portal-sg"
  vpc_id      = aws_vpc.vpc-main.id
  tags = {
    Name = "${var.env}-${var.project}-portal-sg"
  }
}

### security group rules

## sg-pub-lb rules
# HTTP ingress
resource "aws_security_group_rule" "sgr-pub-lb-ingress-1" {
  type              = "ingress"
  security_group_id = aws_security_group.sg-pub-lb.id
  description       = "HTTP ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# HTTPS ingress
resource "aws_security_group_rule" "sgr-pub-lb-ingress-2" {
  type              = "ingress"
  security_group_id = aws_security_group.sg-pub-lb.id
  description       = "HTTPS ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# HTTP egress
resource "aws_security_group_rule" "sgr-pub-lb-egress-1" {
  type              = "egress"
  security_group_id = aws_security_group.sg-pub-lb.id
  description       = "HTTP egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# HTTPS egress
resource "aws_security_group_rule" "sgr-pub-lb-egress-2" {
  type              = "egress"
  security_group_id = aws_security_group.sg-pub-lb.id
  description       = "HTTPS egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}



## sg-http-outbound rules
# HTTP egress
resource "aws_security_group_rule" "sgr-http-egress-1" {
  type              = "egress"
  security_group_id = aws_security_group.sg-http-outbound.id
  description       = "HTTP egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# HTTPS egress
resource "aws_security_group_rule" "sgr-http-egress-2" {
  type              = "egress"
  security_group_id = aws_security_group.sg-http-outbound.id
  description       = "HTTPS egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}



## sg-ses-outbound rules
# SMTP to SES
resource "aws_security_group_rule" "sgr-ses-egress-1" {
  type              = "egress"
  security_group_id = aws_security_group.sg-ses-outbound.id
  description       = "SMTP to SES"
  from_port         = 587
  to_port           = 587
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}



## sg-pub-bastion rules
# SSH
resource "aws_security_group_rule" "sgr-pub-bastion-ingress-1" {
  type              = "ingress"
  security_group_id = aws_security_group.sg-pub-bastion.id
  description       = "Whitelisted SSH IPs"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.vpc_cidr_whitelist_main
}

# DB
resource "aws_security_group_rule" "sgr-pub-bastion-egress-2" {
  type                     = "egress"
  security_group_id        = aws_security_group.sg-pub-bastion.id
  description              = "DB egress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg-db-aurora.id
}

# Redis cache
resource "aws_security_group_rule" "sgr-pub-bastion-egress-3" {
  type                     = "egress"
  security_group_id        = aws_security_group.sg-pub-bastion.id
  description              = "Redis cache egress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg-cache-redis.id
}

# All traffic (for using apt)
resource "aws_security_group_rule" "sgr-pub-bastion-egress-5" {
  type              = "egress"
  security_group_id = aws_security_group.sg-pub-bastion.id
  description       = "All traffic for apt comands"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}



## sg-app rules
# HTTPS
resource "aws_security_group_rule" "sgr-app-ingress-1" {
  type                     = "ingress"
  security_group_id        = aws_security_group.sg-app.id
  description              = "HTTPS from LBs"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg-pub-lb.id
}

resource "aws_security_group_rule" "sgr-app-ingress-2" {
  type                     = "ingress"
  security_group_id        = aws_security_group.sg-app.id
  description              = "HTTPS from LBs"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg-pub-lb.id
}

# DB
resource "aws_security_group_rule" "sgr-app-egress-2" {
  type                     = "egress"
  security_group_id        = aws_security_group.sg-app.id
  description              = "DB egress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg-db-aurora.id
}

# Redis cache
resource "aws_security_group_rule" "sgr-app-egress-3" {
  type                     = "egress"
  security_group_id        = aws_security_group.sg-app.id
  description              = "Redis cache egress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg-cache-redis.id
}



## sg-chat rules
# DB
resource "aws_security_group_rule" "sgr-chat-egress-1" {
  type                     = "egress"
  security_group_id        = aws_security_group.sg-chat.id
  description              = "DB egress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg-db-aurora.id
}

# Redis cache
resource "aws_security_group_rule" "sgr-chat-egress-2" {
  type                     = "egress"
  security_group_id        = aws_security_group.sg-chat.id
  description              = "Redis cache egress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg-cache-redis.id
}

## sg-db-aurora rules
# DB ingress from apps
resource "aws_security_group_rule" "sgr-db-aurora-ingress-1" {
  type                     = "ingress"
  security_group_id        = aws_security_group.sg-db-aurora.id
  description              = "DB ingress from apps"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg-app.id
}

# DB ingress from chats
resource "aws_security_group_rule" "sgr-db-aurora-ingress-2" {
  type                     = "ingress"
  security_group_id        = aws_security_group.sg-db-aurora.id
  description              = "DB ingress from chats"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg-chat.id
}

# DB ingress from bastion
resource "aws_security_group_rule" "sgr-db-aurora-ingress-3" {
  type                     = "ingress"
  security_group_id        = aws_security_group.sg-db-aurora.id
  description              = "DB ingress from bastion"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg-pub-bastion.id
}



## .sg-cache-redis rules
# Redis ingress from apps
resource "aws_security_group_rule" "sgr-cache-redis-ingress-1" {
  type                     = "ingress"
  security_group_id        = aws_security_group.sg-cache-redis.id
  description              = "Redis ingress from apps"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg-app.id
}

# Redis ingress from chats
resource "aws_security_group_rule" "sgr-cache-redis-ingress-2" {
  type                     = "ingress"
  security_group_id        = aws_security_group.sg-cache-redis.id
  description              = "Redis ingress from chats"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg-chat.id
}

# Redis ingress from bastion
resource "aws_security_group_rule" "sgr-cache-redis-ingress-3" {
  type                     = "ingress"
  security_group_id        = aws_security_group.sg-cache-redis.id
  description              = "Redis ingress from bastion"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg-pub-bastion.id
}


resource "aws_security_group_rule" "sgr-frontend-ingress-1" {
  type                     = "ingress"
  security_group_id        = aws_security_group.sg-frontend.id
  description              = "HTTPS from LBs"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg-pub-lb.id
}
resource "aws_security_group_rule" "sgr-frontend-ingress-2" {
  type                     = "ingress"
  security_group_id        = aws_security_group.sg-frontend.id
  description              = "HTTPS from LBs"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg-pub-lb.id
}
resource "aws_security_group_rule" "sgr-portal-ingress-1" {
  type                     = "ingress"
  security_group_id        = aws_security_group.sg-portal.id
  description              = "HTTPS from LBs"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg-pub-lb.id
}
resource "aws_security_group_rule" "sgr-portal-ingress-2" {
  type                     = "ingress"
  security_group_id        = aws_security_group.sg-portal.id
  description              = "HTTPS from LBs"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg-pub-lb.id
}