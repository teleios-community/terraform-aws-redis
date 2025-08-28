variable "project_prefix" {
  type = string
  description = "Resource name prefix (e.g., teleios-idris)"
}
variable "vpc_id" { type = string }

variable "app_sg_id" { type = string } # Onitcha's EC2 SG – allowed to talk to Redis

variable "engine_version" {
  type    = string
  default = "7.1"
}
variable "node_type" {
  type    = string
  default = "cache.t4g.micro"
}

variable "port" {
  type    = number
  default = 6379
}

# High availability knobs (cost sensitive!)
variable "multi_az_enabled" {
  type    = bool
  default = false
}

variable "allowed_from_sg_id" { type = string }
variable "redis_vpc_id"       { type = string }
variable "subnet_ids"         { type = list(string) }

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for Redis (>=2 for HA)"
  validation {
    condition     = length(var.private_subnet_ids) >= (var.replica_count > 0 ? 2 : 1)
    error_message = "Provide at least 2 private subnets when replica_count > 0."
  }
}

variable "replica_count" {
  type        = number
  default     = 0
  description = "Number of read replicas (0-5). 0 = single-node."
  validation {
    condition     = var.replica_count >= 0 && var.replica_count <= 5
    error_message = "replica_count must be between 0 and 5."
  }
}

variable "auth_token" {
  type        = string
  sensitive   = true
  default     = null
  description = "Redis AUTH token (16–128 chars) when enabling engine auth; null disables AUTH."
  validation {
    condition     = var.auth_token == null || (length(var.auth_token) >= 16 && length(var.auth_token) <= 128)
    error_message = "auth_token must be 16–128 characters when set."
  }
}

# Maintenance & backups (production-minded, safe defaults for dev)
variable "maintenance_window" {
  type    = string
  default = "sun:03:00-sun:04:00"
}
variable "snapshot_window" {
  type    = string
  default = "04:00-05:00"
}
variable "snapshot_retention" {
  type    = number
  default = 2
} # 0 => off in dev; set >0 in prod

variable "tags" {
  type = map(string)
  default = {
    Project     = "Teleios-Ecommerce"
    Environment = "dev"
    ManagedBy   = "Terraform"
    Owner       = "TeleiosTeam"
  }
}