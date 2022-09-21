## route tables
resource "aws_route_table" "rt-pub-main" {
  vpc_id = aws_vpc.vpc-main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-main.id
  }

  tags = {
    Name = "${var.env}-${var.project}-pub-route"

  }
}

resource "aws_route_table" "rt-db-main" {
  vpc_id = aws_vpc.vpc-main.id

  tags = {
    Name = "${var.env}-${var.project}-db-route"

  }
}

resource "aws_route_table" "rt-nat-main" {
  count  = length(var.vpc_azs_app_nat)
  vpc_id = aws_vpc.vpc-main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-main.id
  }

  tags = {
    Name = "${var.env}-${var.project}-nat-igw-route-az${count.index + 1}"

  }
}

resource "aws_route_table" "rt-app-main" {
  count  = length(var.vpc_azs_app_nat)
  vpc_id = aws_vpc.vpc-main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.natgw-main.*.id, count.index)
  }

  tags = {
    Name = "${var.env}-${var.project}-app-route-az${count.index + 1}"

  }
}

## route table associations
resource "aws_route_table_association" "rt-assoc-pub-main" {
  count          = length(var.vpc_azs_main)
  route_table_id = aws_route_table.rt-pub-main.id
  subnet_id      = element(aws_subnet.sub-pub-main.*.id, count.index)
}

resource "aws_route_table_association" "rt-assoc-db-main" {
  count          = length(var.vpc_azs_main)
  route_table_id = aws_route_table.rt-db-main.id
  subnet_id      = element(aws_subnet.sub-db-main.*.id, count.index)
}

resource "aws_route_table_association" "rt-assoc-nat-main" {
  count          = length(var.vpc_azs_app_nat)
  route_table_id = element(aws_route_table.rt-nat-main.*.id, count.index)
  subnet_id      = element(aws_subnet.sub-nat-main.*.id, count.index)
}

resource "aws_route_table_association" "rt-assoc-app-main" {
  count          = length(var.vpc_azs_app_nat)
  route_table_id = element(aws_route_table.rt-app-main.*.id, count.index)
  subnet_id      = element(aws_subnet.sub-app-main.*.id, count.index)
}
