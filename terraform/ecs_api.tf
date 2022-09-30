resource "aws_ecs_task_definition" "ecs-task-definition-api" {
  family                   = "${var.env}-${var.project}-api-task"
  execution_role_arn       = aws_iam_role.ecs-task-execution-role.arn
  task_role_arn            = aws_iam_role.ecs-task-execution-role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_taskdef_cpu["api"]
  memory                   = var.ecs_taskdef_memory["api"]

  container_definitions = jsonencode([
    {
      name              = "${element(var.ecs_containers_main, index(var.ecs_containers_main, "api"))}",
      image             = var.ecs_taskdef_repository["api"],
      cpu               = var.ecs_taskdef_cpu["api"],
      memoryReservation = var.ecs_taskdef_memory["api"],

      portMappings = [
        {
          containerPort = var.ecs_taskdef_containerport
        }
      ],

      environment = [
        {
          name  = "env",
          value = var.env
        },
        {
          name  = "DB_CONNECTION",
          value = "pgsql"
        },
        {
          name  = "DB_HOST",
          value = aws_rds_cluster.rds-cluster-main.endpoint
        },
        {
          name  = "DB_USERNAME",
          value = var.db_instance_master_uname_main
        },
        {
          name  = "DB_DATABASE",
          value = "svstgndb"
        },

        {
          name  = "PEXIP_HOST_IP",
          value = var.PEXIP_HOST_IP
        },
        {
          name  = "PEXIP_HOST",
          value = var.PEXIP_HOST
        },
        {
          name  = "PEXIP_CONFERENCING_NODE_PARENT",
          value = var.PEXIP_CONFERENCING_NODE_PARENT
        },
        {
          name  = "PEXIP_CONFERENCING_NODE",
          value = var.PEXIP_CONFERENCING_NODE
        },
        {
          name  = "SENTRY_LARAVEL_DSN",
          value = var.SENTRY_LARAVEL_DSN_API
        },
        {
          name  = "REPORT_SENTRY",
          value = "true"
        },
        {
          name  = "APP_KEY",
          value = var.APP_KEY_API
        },
        {
          name  = "SAAS_URL_PATTERN",
          value = "/.*/"
        },
        {
          name  = "MAIL_HOST",
          value = var.MAIL_HOST
        },
        {
          name  = "MAIL_PORT",
          value = tostring(var.MAIL_PORT)
        },
        {
          name  = "MAIL_DRIVER",
          value = var.MAIL_DRIVER
        },
        {
          name  = "MAIL_FROM_ADDRESS",
          value = var.MAIL_FROM_ADDRESS
        },
        {
          name  = "MAIL_FROM_NAME",
          value = var.MAIL_FROM_NAME
        },
        {
          name  = "ACTIVE_CAMPAIGN_URL",
          value = var.ACTIVE_CAMPAIGN_URL
        },
        {
          name  = "ACTIVE_CAMPAIGN_API_KEY",
          value = var.ACTIVE_CAMPAIGN_API_KEY
        },
        {
          name  = "ACTIVE_CAMPAIGN_API_VERSION",
          value = tostring(var.ACTIVE_CAMPAIGN_API_VERSION)
        },
        {
          name  = "ACTIVE_CAMPAIGN_BASE_LIST_ID",
          value = tostring(var.ACTIVE_CAMPAIGN_BASE_LIST_ID)
        },
        {
          name  = "CHAT_API_SECRET",
          value = var.CHAT_API_SECRET
        },
        {
          name = "APP_URL",
          value = "https://api.${var.domain}/"
        },
        {
          name = "CHAT_API_HOST",
          value = "https://chat.${var.domain}/"
        },
        {
          name = "FRONTEND_URL"
          value = "https://${var.domain}"
        },
        {
          name = "JWT_SECRET",
          value = var.JWT_SECRET
        },
        {
          name = "AWS_BUCKET",
          value = "svstgn" //aws_s3_bucket.recording.bucket
        },
        {
          name = "AWS_DEFAULT_REGION",
          valeu = "eu-west-2"
        },
        {
          name = "WOWZA_RTMP",
          value = "rtmp://rec.simplyvideo.net/stgn"
        },
        {
          name = "RECORDING_PARTICIPANT_NAME",
          value = "rec.simplyvideo.net"
        }

        # {
        #   name = "CACHE_DRIVER",
        #   value = "redis"
        # }
      ],
      secrets = [
        {
          name      = "DB_PASSWORD",
          valueFrom = data.aws_ssm_parameter.rds_password.id
        },
        {
          name      = "PEXIP_PASSWORD",
          valueFrom = data.aws_ssm_parameter.PEXIP_PASSWORD.id
        },
        {
          name      = "PEXIP_USER",
          valueFrom = data.aws_ssm_parameter.PEXIP_USER.id
        },
        {
          name      = "MAIL_USERNAME",
          valueFrom = data.aws_ssm_parameter.MAIL_USERNAME.id
        },
        {
          name      = "MAIL_PASSWORD",
          valueFrom = data.aws_ssm_parameter.MAIL_PASSWORD.id
        },
        {
          name = "PUSHER_APP_KEY",
          valueFrom = data.aws_ssm_parameter.PUSHER_APP_KEY.id
        },
        {
          name = "AWS_ACCESS_KEY_ID",
          valueFrom = data.aws_ssm_parameter.recording_key_id.id
        },
        {
          name = "AWS_SECRET_ACCESS_KEY",
          valueFrom = data.aws_ssm_parameter.recording_secret.id
        }
      ],

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "/ecs/${var.env}-${var.project}-${element(var.ecs_containers_main, index(var.ecs_containers_main, "api"))}-task",
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

resource "aws_ecs_service" "ecs-service-api" {
  name    = "${var.env}-${var.project}-api-service"
  cluster = aws_ecs_cluster.ecs-cluster-main.id

  task_definition  = aws_ecs_task_definition.ecs-task-definition-api.arn
  desired_count    = var.ecs_service_desired_count["api"]
  launch_type      = "FARGATE"
  platform_version = var.ecs_service_platform_version

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  lifecycle {
    create_before_destroy = "true"
  }

  network_configuration {
    subnets          = aws_subnet.sub-app-main.*.id
    security_groups  = [aws_security_group.sg-app.id, aws_security_group.sg-http-outbound.id, aws_security_group.sg-ses-outbound.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb-tg-api.arn
    container_name   = element(var.ecs_containers_main, index(var.ecs_containers_main, "api"))
    container_port   = var.ecs_taskdef_containerport
  }

  tags = {
    Name = "${var.env}-${var.project}-api-service"
  }
}

resource "aws_appautoscaling_target" "ecs-autoscaling-target-api" {
  min_capacity       = var.ecs_autoscaling_min_tasks["api"]
  max_capacity       = var.ecs_autoscaling_max_tasks["api"]
  resource_id        = "service/${aws_ecs_cluster.ecs-cluster-main.name}/${aws_ecs_service.ecs-service-api.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_ecs_service.ecs-service-api]
}

resource "aws_appautoscaling_policy" "ecs-autoscaling-policy-api" {
  name               = "${var.env}-${var.project}-service-autoscale-policy-api"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs-autoscaling-target-api.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs-autoscaling-target-api.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs-autoscaling-target-api.service_namespace

  depends_on = [aws_ecs_service.ecs-service-api]

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = var.ecs_autoscaling_trigger_target["api"]
    scale_in_cooldown  = var.ecs_autoscaling_scaleincooldown["api"]
    scale_out_cooldown = var.ecs_autoscaling_scaleoutcooldown["api"]
    disable_scale_in   = false
  }
}