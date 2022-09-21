resource "aws_subnet" "sub-pub-main" {
  count                   = length(var.vpc_azs_main)
  vpc_id                  = aws_vpc.vpc-main.id
  availability_zone       = "${var.aws_region}${element(var.vpc_azs_main, count.index)}"
  cidr_block              = cidrsubnet(aws_vpc.vpc-main.cidr_block, 8, count.index + 1)
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.env}-${var.project}-pub-sub-az${count.index + 1}"
  }
}

resource "aws_subnet" "sub-db-main" {
  count                   = length(var.vpc_azs_main)
  vpc_id                  = aws_vpc.vpc-main.id
  availability_zone       = "${var.aws_region}${element(var.vpc_azs_main, count.index)}"
  cidr_block              = cidrsubnet(aws_vpc.vpc-main.cidr_block, 8, count.index + 21)
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.env}-${var.project}-db-sub-az${count.index + 1}"
  }
}

resource "aws_subnet" "sub-nat-main" {
  count                   = length(var.vpc_azs_app_nat)
  vpc_id                  = aws_vpc.vpc-main.id
  availability_zone       = "${var.aws_region}${element(var.vpc_azs_app_nat, count.index)}"
  cidr_block              = cidrsubnet(aws_vpc.vpc-main.cidr_block, 8, count.index + 251)
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.env}-${var.project}-nat-sub-az${count.index + 1}"
  }
}

resource "aws_subnet" "sub-app-main" {
  count                   = length(var.vpc_azs_app_nat)
  vpc_id                  = aws_vpc.vpc-main.id
  availability_zone       = "${var.aws_region}${element(var.vpc_azs_app_nat, count.index)}"
  cidr_block              = cidrsubnet(aws_vpc.vpc-main.cidr_block, 8, count.index + 11)
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.env}-${var.project}-app-sub-main-az${count.index + 1}"
  }
}