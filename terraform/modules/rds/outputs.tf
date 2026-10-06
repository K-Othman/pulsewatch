output "address" {
  description = "Hostname the app connects to"
  value       = aws_db_instance.this.address
}

output "port" {
  description = "Port the database listens on"
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "Name of the database"
  value       = aws_db_instance.this.db_name
}

output "master_user_secret_arn" {
  description = "Secrets Manager secret holding the username and password"
  value       = aws_db_instance.this.master_user_secret[0].secret_arn
}

output "identifier" {
  description = "Instance identifier, used by CloudWatch alarms"
  value       = aws_db_instance.this.identifier
}