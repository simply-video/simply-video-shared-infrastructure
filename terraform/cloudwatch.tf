resource "aws_cloudwatch_log_group" "cw-log-main" {
  count = length(var.ecs_containers_main)
  name  = "/ecs/${var.env}-${var.project}-${element(var.ecs_containers_main, count.index)}-task"

  tags = {
    Name = "${var.env}-${var.project}-cw-log-group"
  }
}