locals {
  name_base = "${var.project_prefix}-redis"
}

# Parameter group (optional tuning – safe to keep default family)
resource "aws_elasticache_parameter_group" "this" {
  name   = "${local.name_base}-param"
  family = "redis7"
  tags   = var.tags
}


# Subnet group (private subnets only)
resource "aws_elasticache_subnet_group" "this" {
  name       = "${local.name_base}-subnets"
  subnet_ids = var.private_subnet_ids
  tags       = var.tags
}


# Security Group for Redis (ingress ONLY from app SG on port 6379)
resource "aws_security_group" "redis" {
  name        = "${local.name_base}-sg"
  description = "Redis access from App EC2 only"
  vpc_id      = var.vpc_id
  tags        = var.tags

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "from_app_to_redis" {
  type                     = "ingress"
  security_group_id        = aws_security_group.redis.id
  from_port                = var.port
  to_port                  = var.port
  protocol                 = "tcp"
  source_security_group_id = var.app_sg_id
  description              = "Allow App EC2 to reach Redis"
}

# Replication group (works for single-node or HA)
resource "aws_elasticache_replication_group" "this" {
  replication_group_id = "${replace(local.name_base, "_", "-")}-rg"
  description          = "Teleios Week8 Redis for ${var.project_prefix}"

  engine         = "redis"
  engine_version = var.engine_version
  node_type      = var.node_type
  port           = var.port

  parameter_group_name = aws_elasticache_parameter_group.this.name
  subnet_group_name    = aws_elasticache_subnet_group.this.name
  security_group_ids   = [aws_security_group.redis.id]

  # Encryption
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true

  # Auth token (null in dev, set in prod)
  auth_token = var.auth_token

  # ---- Non-clustered, single-node (dev/cost-safe) ----
  num_cache_clusters         = 1
  automatic_failover_enabled = false
  multi_az_enabled           = false

  # Maintenance & snapshots
  maintenance_window       = var.maintenance_window
  snapshot_window          = var.snapshot_window
  snapshot_retention_limit = var.snapshot_retention

  tags = var.tags
}
