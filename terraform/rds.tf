resource "aws_db_subnet_group" "db-subnet-group-main" {
  name        = "${var.env}-${var.project}-aurora-postgresql-db"
  description = "Aurora DB subnet group"
  subnet_ids  = aws_subnet.sub-db-main.*.id

  tags = {
    Name = "${var.env}-${var.project}-aurora-postgresql-db"

  }
}

resource "aws_rds_cluster_parameter_group" "db-cluster-param-group" {
  name        = "${var.env}-${var.project}-${var.db_instance_engine_name_main}-cluster"
  description = "${var.env}-${var.project}-${var.db_instance_engine_name_main}-${var.db_instance_engine_ver_major} cluster"
  family      = "${var.db_instance_engine_name_main}${var.db_instance_engine_ver_major}"

  parameter {
    apply_method = "pending-reboot"
    name         = "max_connections"
    value        = var.db_param_max_connections
  }

  tags = {
    Name = "${var.env}-${var.project}-param-group-cluster"

  }
}

resource "aws_rds_cluster" "rds-cluster-main" {
  cluster_identifier                  = "${var.env}-${var.project}-aurora-postgresql-cluster"
  engine                              = var.db_instance_engine_name_main
  engine_version                      = "${var.db_instance_engine_ver_major}.${var.db_instance_engine_ver_minor}"
  master_username                     = var.db_instance_master_uname_main
  master_password                     = data.aws_ssm_parameter.rds_password.value
  db_cluster_parameter_group_name     = aws_rds_cluster_parameter_group.db-cluster-param-group.id
  db_subnet_group_name                = aws_db_subnet_group.db-subnet-group-main.id
  vpc_security_group_ids              = [aws_security_group.sg-db-aurora.id]
  backup_retention_period             = var.db_instance_backup_retention_main
  preferred_backup_window             = var.db_instance_backup_window_main
  preferred_maintenance_window        = var.db_instance_maintenance_window_main
  deletion_protection                 = var.db_instance_deletion_protection
  kms_key_id                          = data.aws_kms_key.kms-rds-main.arn
  storage_encrypted                   = true
  copy_tags_to_snapshot               = true
  iam_database_authentication_enabled = false
  enabled_cloudwatch_logs_exports     = ["postgresql"]

  tags = {
    Name = "${var.env}-${var.project}-aurora-postgresql-cluster"

  }
}

resource "aws_rds_cluster_instance" "rds-cluster-instance-main" {
  count                      = var.db_autoscaling_enabled ? var.db_autoscaling_min_capacity + 1 : 1
  identifier_prefix          = "${var.env}-${var.project}-db-"
  cluster_identifier         = aws_rds_cluster.rds-cluster-main.id
  instance_class             = var.db_instance_class_main
  engine                     = var.db_instance_engine_name_main
  engine_version             = "${var.db_instance_engine_ver_major}.${var.db_instance_engine_ver_minor}"
  db_subnet_group_name       = aws_db_subnet_group.db-subnet-group-main.id
  copy_tags_to_snapshot      = "true"
  auto_minor_version_upgrade = "true"

  tags = {
    Name = "${var.env}-${var.project}-db"

  }
}

resource "aws_appautoscaling_target" "rds-autoscaling-replicas-main" {
  count              = var.db_autoscaling_enabled ? 1 : 0
  service_namespace  = "rds"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  resource_id        = "cluster:${aws_rds_cluster.rds-cluster-main.id}"
  min_capacity       = var.db_autoscaling_min_capacity
  max_capacity       = var.db_autoscaling_max_capacity
}

resource "aws_appautoscaling_policy" "rds-autoscaling-replicas-policy-main" {
  count              = var.db_autoscaling_enabled ? 1 : 0
  name               = "cpu-auto-scaling"
  service_namespace  = aws_appautoscaling_target.rds-autoscaling-replicas-main[0].service_namespace
  scalable_dimension = aws_appautoscaling_target.rds-autoscaling-replicas-main[0].scalable_dimension
  resource_id        = aws_appautoscaling_target.rds-autoscaling-replicas-main[0].resource_id
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "RDSReaderAverageCPUUtilization"
    }

    target_value       = var.db_autoscaling_cpu_target_value
    scale_in_cooldown  = var.db_autoscaling_scale_in_cooldown
    scale_out_cooldown = var.db_autoscaling_scale_out_cooldown
  }
}