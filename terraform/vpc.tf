resource "aws_vpc" "vpc-main" {
  cidr_block           = var.vpc_cidr_main
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "${var.env}-${var.project}-vpc"
  }
}

resource "aws_internet_gateway" "igw-main" {
  vpc_id = aws_vpc.vpc-main.id

  tags = {
    Name = "${var.env}-${var.project}-igw"
  }
}

resource "aws_eip" "eip-nat-main" {
  count = length(var.vpc_azs_app_nat)
  vpc   = true

  tags = {
    Name = "${var.env}-${var.project}-eip-az${count.index + 1}"
  }
}

resource "aws_nat_gateway" "natgw-main" {
  count         = length(var.vpc_azs_app_nat)
  allocation_id = element(aws_eip.eip-nat-main.*.id, count.index)
  subnet_id     = element(aws_subnet.sub-nat-main.*.id, count.index)

  tags = {
    Name = "${var.env}-${var.project}-nat-az${count.index + 1}"
  }
}

resource "aws_default_network_acl" "nacl-default" {
  default_network_acl_id = aws_vpc.vpc-main.default_network_acl_id

  lifecycle {
    ignore_changes = [subnet_ids]
  }

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${var.env}-${var.project}-nacl"
  }
}