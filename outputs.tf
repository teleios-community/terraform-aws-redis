output "redis_primary_endpoint" {
  description = "Primary endpoint hostname (TLS)"
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}


output "redis_reader_endpoint" {
  description = "Reader endpoint hostname (if replicas)"
  value       = aws_elasticache_replication_group.this.reader_endpoint_address
}


output "redis_sg_id" {
  value = aws_security_group.redis.id
}


output "redis_subnet_group" {
  value = aws_elasticache_subnet_group.this.name
}