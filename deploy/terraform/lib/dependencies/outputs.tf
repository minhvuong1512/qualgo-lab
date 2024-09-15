output "nestjs_backend_db_endpoint" {
  description = "Writer endpoint for the nestjs_backend database"
  value       = module.nestjs_backend_rds.cluster_endpoint
}

output "nestjs_backend_db_database_name" {
  description = "Database name for the nestjs_backend database"
  value       = module.nestjs_backend_rds.cluster_database_name
}

output "nestjs_backend_db_master_password" {
  description = "Master password for the nestjs_backend database"
  value       = module.nestjs_backend_rds.cluster_master_password
  sensitive   = true
}

output "nestjs_backend_db_master_username" {
  description = "Master username for the nestjs_backend database"
  value       = module.nestjs_backend_rds.cluster_master_username
  sensitive   = true
}

output "nestjs_backend_db_port" {
  description = "Port for the nestjs_backend database"
  value       = module.nestjs_backend_rds.cluster_port
}

output "nestjs_backend_db_reader_endpoint" {
  description = "A read-only endpoint for the nestjs_backend database"
  value       = module.nestjs_backend_rds.cluster_reader_endpoint
}

output "nestjs_backend_db_arn" {
  description = "ARN for the nestjs_backend database"
  value       = module.nestjs_backend_rds.cluster_arn
}


