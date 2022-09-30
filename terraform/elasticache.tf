resource "aws_elasticache_subnet_group" "ec-subnet-group-main" {
  name        = "${var.env}-${var.project}-elasticache-sub-grp"
  description = "Region Elasticache Subnet Group"
  subnet_ids  = aws_subnet.sub-db-main.*.id
}

resource "aws_elasticache_parameter_group" "ec-param-group" {
  name   = "${var.env}-${var.project}-redis-cluster-ON"
  family = "redis5.0"

  parameter {
    name  = "cluster-enabled"
    value = "yes"
  }

  parameter {
    name  = "maxmemory-policy"
    value = "allkeys-lfu"
  }
}

resource "aws_elasticache_replication_group" "ec-cluster-rg-main" {

  replication_group_id       = "${var.env}-${var.project}"
  description                = "${var.env}-${var.project}-elasticache-redis-replication-group"
  node_type                  = var.ec_cluster_instance_type_main
  parameter_group_name       = aws_elasticache_parameter_group.ec-param-group.id
  subnet_group_name          = aws_elasticache_subnet_group.ec-subnet-group-main.name
  engine                     = "redis"
  engine_version             = var.ec_cluster_engine_version_main
  snapshot_retention_limit   = 0
  security_group_ids         = [aws_security_group.sg-cache-redis.id]
  maintenance_window         = var.ec_cluster_maintenance_window_main
  num_cache_clusters         = var.ec_cluster_replicas_per_shard_main
  automatic_failover_enabled = true
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  auto_minor_version_upgrade = true

  lifecycle {
    ignore_changes = [engine_version]
  }

  tags = {
    Name = "${var.env}-${var.project}-db"
  }
}