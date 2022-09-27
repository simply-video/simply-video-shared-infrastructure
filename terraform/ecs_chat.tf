resource "aws_ecs_task_definition" "ecs-task-definition-chat" {
  family                   = "${var.env}-${var.project}-chat-task"
  execution_role_arn       = aws_iam_role.ecs-task-execution-role.arn
  task_role_arn            = aws_iam_role.ecs-task-execution-role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_taskdef_cpu["chat"]
  memory                   = var.ecs_taskdef_memory["chat"]

  container_definitions = jsonencode([
    {
      name              = "${element(var.ecs_containers_main, index(var.ecs_containers_main, "chat"))}",
      image             = var.ecs_taskdef_repository["chat"],
      cpu               = var.ecs_taskdef_cpu["chat"],
      memoryReservation = var.ecs_taskdef_memory["chat"],

      portMappings = [
        {
          containerPort = var.ecs_taskdef_containerport
        }
      ],

      environment = [
        {
          name  = "env",
          value = "${var.env}"
        }
      ],

      secrets = [
        {
          name = "PUSHER_APP_KEY",
          valueFrom = data.aws_ssm_parameter.MAIL_PASSWORD.id
        }
      ],

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "/ecs/${var.env}-${var.project}-${element(var.ecs_containers_main, index(var.ecs_containers_main, "chat"))}-task",
          awslogs-region        = "${var.aws_region}",
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "${var.env}-${var.project}-api-task"
  }
}

resource "aws_ecs_service" "ecs-service-chat" {
  name    = "${var.env}-${var.project}-chat-service"
  cluster = aws_ecs_cluster.ecs-cluster-main.id

  task_definition  = aws_ecs_task_definition.ecs-task-definition-chat.arn
  desired_count    = var.ecs_service_desired_count["chat"]
  launch_type      = "FARGATE"
  platform_version = var.ecs_service_platform_version

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  lifecycle {
    create_before_destroy = "true"
  }

  network_configuration {
    subnets          = aws_subnet.sub-app-main.*.id
    security_groups  = [aws_security_group.sg-app.id, aws_security_group.sg-http-outbound.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb-tg-chat.arn
    container_name   = element(var.ecs_containers_main, index(var.ecs_containers_main, "chat"))
    container_port   = var.ecs_taskdef_containerport
  }

  tags = {
    Name = "${var.env}-${var.project}-chat-service"
  }
}

resource "aws_appautoscaling_target" "ecs-autoscaling-target-chat" {
  min_capacity       = var.ecs_autoscaling_min_tasks["chat"]
  max_capacity       = var.ecs_autoscaling_max_tasks["chat"]
  resource_id        = "service/${aws_ecs_cluster.ecs-cluster-main.name}/${aws_ecs_service.ecs-service-chat.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_ecs_service.ecs-service-chat]
}

resource "aws_appautoscaling_policy" "ecs-autoscaling-policy-chat" {
  name               = "${var.env}-${var.project}-service-autoscale-policy-chat"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs-autoscaling-target-chat.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs-autoscaling-target-chat.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs-autoscaling-target-chat.service_namespace

  depends_on = [aws_ecs_service.ecs-service-chat]

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = var.ecs_autoscaling_trigger_target["chat"]
    scale_in_cooldown  = var.ecs_autoscaling_scaleincooldown["chat"]
    scale_out_cooldown = var.ecs_autoscaling_scaleoutcooldown["chat"]
    disable_scale_in   = false
  }
}