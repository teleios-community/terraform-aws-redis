variable "project_prefix" {
  type = string
  description = "Resource name prefix (e.g., teleios-idris)"
}
variable "vpc_id" { type = string }
variable "private_subnet_ids" {
  type = list(string)
}

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
variable "replica_count" {
  type    = number
  default = 0
} # 0 => single-node (dev)


# Security and encryption
variable "auth_token" {
  type      = string
  sensitive = true
  default   = null # Provide via TF Cloud/vars. If null => AUTH disabled (dev only)
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
  default = 0
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