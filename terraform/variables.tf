variable "project" {
  description = "project name"
  type        = string
  default     = "simplyvideo"
}

variable "env" {
  description = "Environment name, such as stage, prod etc"
  type        = string
}

variable "aws_region" {
  description = "Platform region"
  type        = string
  default     = "eu-central-1"
}

variable "vpc_cidr_main" {
  description = "VPC CIDR block. Must be unique! Must be at least /16 block."
  type        = string
  default     = "10.100.0.0/16"
}

variable "vpc_azs_main" {
  description = "Availability zones, such as  'a, b, c, d, ..'  as in eu-west-2a, eu-west-2c. Order doesn't matter, though AZ should exist in that AWS region. Minimum two AZs are required! https://aws.amazon.com/about-aws/global-infrastructure/regions_az/"
  type        = list(string)
  default     = ["a", "b"]
}

variable "vpc_azs_app_nat" {
  description = "Availability zones, such as  'a, b, c, d, ..'  as in eu-west-2a, eu-west-2c. Order doesn't matter, though AZ should exist in that AWS region. Minimum two AZs are required! https://aws.amazon.com/about-aws/global-infrastructure/regions_az/"
  type        = list(string)
  default     = ["a"]
}

variable "vpc_cidr_whitelist_main" {
  description = "Whitelistied IPs CIDR. Must be in CIDR format! Please refer to https://managemy.atlassian.net/wiki/spaces/OPS/pages/928841830/Whitelisting"
  type        = list(string)
}

variable "db_instance_engine_name_main" {
  description = "DB engine name The name of the database engine to be used for this DB cluster. Defaults to aurora. Valid Values: aurora, aurora-mysql, aurora-postgresql"
  type        = string
  default     = "aurora-postgresql"
}

variable "db_instance_engine_ver_major" {
  description = "DB engine major version, used in parameter group family. Should match with db_instance_engine_ver_main variable"
  type        = string
  default     = "14"
}

variable "db_instance_engine_ver_minor" {
  description = "DB engine major version, used in parameter group family. Should match with db_instance_engine_ver_main variable"
  type        = string
  default     = "3"
}

variable "db_param_max_connections" {
  description = "DB parameter max_connections. Non-prod environmnets running on db.t3.small are limited to 170 connection by default, this will set new limit via DB parameters. https://sysadminxpert.com/aws-rds-max-connections-limit/ and https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Limits.html#RDS_Limits.MaxConnections"
  type        = number
  default     = 1000
}

variable "db_instance_master_uname_main" {
  description = "DB Username for the master DB user"
  type        = string
  default     = "aurora_rds_root"
}

variable "db_instance_master_pass_main" {
  description = "DB password for the database master user can include any printable ASCII character except /, \", @, or a space. 41 characters max!"
  type        = string
  default     = ""
  sensitive   = true
}

variable "db_instance_backup_retention_main" {
  description = "DB backup retention period in days. The number of days that automatic backups are retained. The minimum value is 1"
  type        = number
  default     = 7
}

variable "db_instance_backup_window_main" {
  description = "DB backup window. The time range during which automated backups of your database occurs. The backup window is a start time in Universal Coordinated Time (UTC), and a duration in hours"
  type        = string
  default     = "00:10-00:40"
}

variable "db_instance_maintenance_window_main" {
  description = "DB maintenance window. The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default     = "Sun:02:00-Sun:02:30"
}

variable "db_instance_deletion_protection" {
  description = "Enable deletion protection to prevent your DB cluster from being deleted. https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_DeleteCluster.html#USER_DeletionProtection"
  type        = bool
  default     = true
}

variable "db_instance_class_main" {
  description = "DB instance class to use. Aurora uses db.* instance classes/types. https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html"
  type        = string
  default     = "db.t3.medium"
}

variable "db_autoscaling_enabled" {
  description = "DB auscaling enabled. Value is true or false. Minimal setup for autoscaling is two instances: master+replica. Referred in 'var.db_autoscaling_enabled ? var.db_autoscaling_min_capacity + 1 : 1' and autoscaling"
  type        = bool
  default     = false
}

variable "db_autoscaling_min_capacity" {
  description = "DB auscaling min_capacity. Minimum number of replicas"
  type        = number
  default     = 1
}

variable "db_autoscaling_max_capacity" {
  description = "DB auscaling max_capacity. Maximum number of replicas"
  type        = number
  default     = 10
}

variable "db_autoscaling_cpu_target_value" {
  description = "DB auscaling cpu target_value. The target value for the metric. (RDSReaderAverageCPUUtilization)"
  type        = number
  default     = 75
}

variable "db_autoscaling_scale_in_cooldown" {
  description = "DB auscaling scale_in_cooldown. The amount of time, in seconds, after a scale in activity completes before another scale in activity can start"
  type        = number
  default     = 300
}

variable "db_autoscaling_scale_out_cooldown" {
  description = "DB auscaling scale_out_cooldown. The amount of time, in seconds, after a scale out activity completes before another scale out activity can start"
  type        = number
  default     = 300
}

variable "ec_cluster_instance_type_main" {
  description = "Elasticache cluster instance type to be used. https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/CacheNodes.SupportedTypes.html and https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/nodes-select-size.html"
  type        = string
  default     = "cache.t2.small"
}

variable "ec_cluster_engine_version_main" {
  description = "Elasticache cluster engine version. https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/supported-engine-versions.html#redis-version-6.x"
  type        = string
  default     = "5.0.0"
}

variable "ec_cluster_maintenance_window_main" {
  description = "Elasticache cluster maintenance window. Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi"
  type        = string
  default     = "Sun:23:00-Mon:00:00"
}

variable "ec_cluster_replicas_per_shard_main" {
  description = "Number of replicas per shard. The number of cache clusters (primary and replicas) this replication group will have. If Multi-AZ is enabled, the value of this parameter must be at least 2"
  type        = number
  default     = 1
}

variable "elasticsearch_version" {
  description = "Number of replicas per shard. The number of cache clusters (primary and replicas) this replication group will have. If Multi-AZ is enabled, the value of this parameter must be at least 2"
  type        = string
  default     = "6.8"
}

variable "elasticsearch_instance_type" {
  description = "Elasticsearch instance type"
  type        = string
  default     = "t3.small.elasticsearch"
}

variable "elasticsearch_zone_awareness_enabled" {
  description = "Elasticsearch zone awareness enabled"
  type        = bool
  default     = false
}

variable "ebs_volume_size" {
  description = "Elastic block store size"
  type        = number
  default     = 10
}

variable "ebs_volume_type" {
  description = "Elastic block store volume type"
  type        = string
  default     = "gp2"
}

variable "auth_bastion_ssh_key" {
  description = "Bastion instance ssh key"
  type        = string
  sensitive   = true
}

variable "lb_listener_https_certificate_arn" {
  description = "AWS arm Certificate for https lb listener"
  type        = string
}

variable "domain" {
  description = "DNS main domain"
  type        = string
}

variable "ecs_containers_main" {
  description = "ECS/ECR services/containers names."
  type        = list(string)
  default     = ["api", "chat", "frontend", "provision_portal"]
}

variable "ecs_taskdef_repository" {
  description = "ECR repositories"
  type = object({
    api      = string
    chat     = string
    frontend = string
    provision_portal = string 
  })
}

variable "ecs_taskdef_cpu" {
  description = "ECS taskdef cpu limit. The number of cpu units the Amazon ECS container agent will reserve for the container"
  type = object({
    api      = number
    chat     = number
    frontend = number
    provision_portal = number
  })
  default = {
    api      = 512
    chat     = 512
    frontend = 512
    provision_portal = 512
  }
}

variable "ecs_taskdef_memory" {
  description = "ECS taskdef memory limit. The hard limit of memory (in MiB) to present to the task. It can be expressed as an integer using MiB, for example 1024"
  type = object({
    api      = number
    chat     = number
    frontend = number
    provision_portal = number
  })
  default = {
    api      = 2048
    chat     = 2048
    frontend = 2048
    provision_portal = 2048
  }
}

variable "ecs_taskdef_containerport" {
  description = "ECS taskdef portmappings_port. The port number on the container that is bound to the user-specified or automatically assigned host port. https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html. Insurer-stub"
  type        = number
  default     = 80
}

variable "ecs_service_desired_count" {
  description = "ECS service desired count. The number of instances of the task definition to place and keep running. Non-prod environments should stick to '1', prod type environmnets must have '2' at a minimum"
  type = object({
    api      = number
    chat     = number
    frontend = number
    provision_portal = number
  })
  default = {
    api      = 1
    chat     = 1
    frontend = 1
    provision_portal= 1
  }
}

variable "ecs_service_platform_version" {
  description = "The AWS Fargate platform version on which to run your service. Values are 1.3.0 or 1.4.0. https://docs.aws.amazon.com/AmazonECS/latest/developerguide/platform_versions.html"
  type        = string
  default     = "1.4.0"
}

variable "ecs_autoscaling_min_tasks" {
  description = "ECS autoscaling_min_tasks. The min capacity of the scalable target"
  type = object({
    api      = number
    chat     = number
    frontend = number
    provision_portal = number
  })
  default = {
    api      = 1
    chat     = 1
    frontend = 1
    provision_portal = 1
  }
}

variable "ecs_autoscaling_max_tasks" {
  description = "ECS autoscaling_min_tasks. The max capacity of the scalable target"
  type = object({
    api      = number
    chat     = number
    frontend = number
    provision_portal = number
  })
  default = {
    api      = 10
    chat     = 10
    frontend = 10
    provision_portal = 10
  }
}

variable "ecs_autoscaling_trigger_target" {
  description = "ECS autoscaling trigger target, such as 70% cpu. The target value for the metric. Based on ECSServiceAverageCPUUtilization metric"
  type = object({
    api      = number
    chat     = number
    frontend = number
    provision_portal = number
  })
  default = {
    api      = 70
    chat     = 70
    frontend = 80
    provision_portal = 80
  }
}

variable "ecs_autoscaling_scaleoutcooldown" {
  description = "ECS autoscaling scaleOutCooldown. The amount of time, in seconds, after a scale out activity completes before another scale out activity can start"
  type = object({
    api      = number
    chat     = number
    frontend = number
    provision_portal = number
  })
  default = {
    api      = 120
    chat     = 120
    frontend = 120
    provision_portal = 120
  }
}

variable "ecs_autoscaling_scaleincooldown" {
  description = "ECS autoscaling scaleInCooldown. The amount of time, in seconds, after a scale in activity completes before another scale in activity can start"
  type = object({
    api      = number
    chat     = number
    frontend = number
    provision_portal= number
  })
  default = {
    api      = 120
    chat     = 120
    frontend = 120
    provision_portal = 120
  }
}


variable "PEXIP_HOST_IP" { type = string }
variable "PEXIP_HOST" { type = string }
variable "PEXIP_PASSWORD" { type = string }
variable "PEXIP_USER" { type = string }
variable "PEXIP_CONFERENCING_NODE_PARENT" { type = string }
variable "PEXIP_CONFERENCING_NODE" { type = string }

variable "SENTRY_LARAVEL_DSN" { type = string }
variable "APP_KEY" { type = string }

variable "MAIL_HOST" {
  type    = string
  default = "smtp.sendgrid.net"
}
variable "MAIL_PORT" {
  type    = number
  default = 587
}
variable "MAIL_DRIVER" {
  type    = string
  default = "smtp"
}
variable "MAIL_FROM_NAME" {
  type    = string
  default = "SimplyVideo"
}
variable "MAIL_USERNAME" { type = string }
variable "MAIL_PASSWORD" { type = string }
variable "MAIL_FROM_ADDRESS" { type = string }

variable "ACTIVE_CAMPAIGN_URL" { type = string }
variable "ACTIVE_CAMPAIGN_API_KEY" { type = string }
variable "ACTIVE_CAMPAIGN_API_VERSION" { type = number }
variable "ACTIVE_CAMPAIGN_BASE_LIST_ID" { type = number }

variable "provision_portal_API_HOST" {
  type    = string
  default = "https://provision_portalapistgn.simplyvideo.net"
}
variable "provision_portal_API_SECRET" { type = string }