resource "aws_ecs_cluster" "ecs-cluster-main" {
  name = "${var.env}-${var.project}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${var.env}-${var.project}-ecs-cluster"
  }
}