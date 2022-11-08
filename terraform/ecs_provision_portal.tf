resource "aws_ecs_task_definition" "ecs-task-definition-provision_portal" {
  family                   = "${var.env}-${var.project}-provision_portal-task"
  execution_role_arn       = aws_iam_role.ecs-task-execution-role.arn
  task_role_arn            = aws_iam_role.ecs-task-execution-role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_taskdef_cpu["provision_portal"]
  memory                   = var.ecs_taskdef_memory["provision_portal"]

  container_definitions = jsonencode([
    {
      name              = "${element(var.ecs_containers_main, index(var.ecs_containers_main, "provision_portal"))}",
      image             = var.ecs_taskdef_repository["provision_portal"],
      cpu               = var.ecs_taskdef_cpu["provision_portal"],
      memoryReservation = var.ecs_taskdef_memory["provision_portal"],

      portMappings = [
        {
          containerPort = var.ecs_taskdef_containerport
        }
      ],

      environment = [
        {
          name = "VUE_APP_API_URL",
          value = "https://api.${var.domain}/api/"
        },
        {
          name = "VUE_APP_SENTRY_DSN"
          value = var.SENTRY_LARAVEL_DSN_PROVISION_PORTAL
        }
      ],

      secrets = [
      ],

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "/ecs/${var.env}-${var.project}-${element(var.ecs_containers_main, index(var.ecs_containers_main, "provision_portal"))}-task",
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

resource "aws_ecs_service" "ecs-service-provision_portal" {
  name    = "${var.env}-${var.project}-provision_portal-service"
  cluster = aws_ecs_cluster.ecs-cluster-main.id

  task_definition  = aws_ecs_task_definition.ecs-task-definition-provision_portal.arn
  desired_count    = var.ecs_service_desired_count["provision_portal"]
  launch_type      = "FARGATE"
  platform_version = var.ecs_service_platform_version

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  lifecycle {
    create_before_destroy = "true"
  }

  network_configuration {
    subnets          = aws_subnet.sub-app-main.*.id
    security_groups  = [aws_security_group.sg-portal.id, aws_security_group.sg-http-outbound.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb-tg-provision_portal.arn
    container_name   = element(var.ecs_containers_main, index(var.ecs_containers_main, "provision_portal"))
    container_port   = var.ecs_taskdef_containerport
  }

  tags = {
    Name = "${var.env}-${var.project}-provision_portal-service"
  }
}

resource "aws_appautoscaling_target" "ecs-autoscaling-target-provision_portal" {
  min_capacity       = var.ecs_autoscaling_min_tasks["provision_portal"]
  max_capacity       = var.ecs_autoscaling_max_tasks["provision_portal"]
  resource_id        = "service/${aws_ecs_cluster.ecs-cluster-main.name}/${aws_ecs_service.ecs-service-provision_portal.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_ecs_service.ecs-service-provision_portal]
}

resource "aws_appautoscaling_policy" "ecs-autoscaling-policy-provision_portal" {
  name               = "${var.env}-${var.project}-service-autoscale-policy-provision_portal"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs-autoscaling-target-provision_portal.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs-autoscaling-target-provision_portal.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs-autoscaling-target-provision_portal.service_namespace

  depends_on = [aws_ecs_service.ecs-service-provision_portal]

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = var.ecs_autoscaling_trigger_target["provision_portal"]
    scale_in_cooldown  = var.ecs_autoscaling_scaleincooldown["provision_portal"]
    scale_out_cooldown = var.ecs_autoscaling_scaleoutcooldown["provision_portal"]
    disable_scale_in   = false
  }
}