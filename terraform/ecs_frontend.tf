resource "aws_ecs_task_definition" "ecs-task-definition-frontend" {
  family                   = "${var.env}-${var.project}-frontend-task"
  execution_role_arn       = aws_iam_role.ecs-task-execution-role.arn
  task_role_arn            = aws_iam_role.ecs-task-execution-role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_taskdef_cpu["frontend"]
  memory                   = var.ecs_taskdef_memory["frontend"]

  container_definitions = jsonencode([
    {
      name              = "${element(var.ecs_containers_main, index(var.ecs_containers_main, "frontend"))}",
      image             = var.ecs_taskdef_repository["frontend"],
      cpu               = var.ecs_taskdef_cpu["frontend"],
      memoryReservation = var.ecs_taskdef_memory["frontend"],

      portMappings = [
        {
          containerPort = var.ecs_taskdef_containerport
        }
      ],

      environment = [
        {
          name  = "env",
          value = "${var.env}",
        },
        {
          name  = "NODE_ENV",
          value = "shared",
        }
      ],

      secrets = [
      ],

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "/ecs/${var.env}-${var.project}-${element(var.ecs_containers_main, index(var.ecs_containers_main, "frontend"))}-task",
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

resource "aws_ecs_service" "ecs-service-frontend" {
  name    = "${var.env}-${var.project}-frontend-service"
  cluster = aws_ecs_cluster.ecs-cluster-main.id

  task_definition  = aws_ecs_task_definition.ecs-task-definition-frontend.arn
  desired_count    = var.ecs_service_desired_count["frontend"]
  launch_type      = "FARGATE"
  platform_version = var.ecs_service_platform_version

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  lifecycle {
    create_before_destroy = "true"
  }

  network_configuration {
    subnets          = aws_subnet.sub-app-main.*.id
    security_groups  = [aws_security_group.sg-frontend.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb-tg-frontend.arn
    container_name   = element(var.ecs_containers_main, index(var.ecs_containers_main, "frontend"))
    container_port   = var.ecs_taskdef_containerport
  }

  tags = {
    Name = "${var.env}-${var.project}-frontend-service"
  }
}

resource "aws_appautoscaling_target" "ecs-autoscaling-target-frontend" {
  min_capacity       = var.ecs_autoscaling_min_tasks["frontend"]
  max_capacity       = var.ecs_autoscaling_max_tasks["frontend"]
  resource_id        = "service/${aws_ecs_cluster.ecs-cluster-main.name}/${aws_ecs_service.ecs-service-frontend.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_ecs_service.ecs-service-frontend]
}

resource "aws_appautoscaling_policy" "ecs-autoscaling-policy-frontend" {
  name               = "${var.env}-${var.project}-service-autoscale-policy-frontend"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs-autoscaling-target-frontend.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs-autoscaling-target-frontend.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs-autoscaling-target-frontend.service_namespace

  depends_on = [aws_ecs_service.ecs-service-frontend]

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = var.ecs_autoscaling_trigger_target["frontend"]
    scale_in_cooldown  = var.ecs_autoscaling_scaleincooldown["frontend"]
    scale_out_cooldown = var.ecs_autoscaling_scaleoutcooldown["frontend"]
    disable_scale_in   = false
  }
}