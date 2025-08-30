output "primary_endpoint"  { value = aws_elasticache_replication_group.this.primary_endpoint_address }
output "reader_endpoint"   { value = aws_elasticache_replication_group.this.reader_endpoint_address }
output "port"              { value = aws_elasticache_replication_group.this.port }
output "subnet_group_name" { value = aws_elasticache_subnet_group.this.name }
