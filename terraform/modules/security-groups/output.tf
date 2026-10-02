output "alb_sg_id" {
  description = "Security group for the ALB"
  value       = aws_security_group.alb.id
}

output "web_sg_id" {
  description = "Security group for ECS web tasks"
  value       = aws_security_group.web.id
}

output "worker_sg_id" {
  description = "Security group for ECS worker tasks"
  value       = aws_security_group.worker.id
}

output "rds_sg_id" {
  description = "Security group for RDS"
  value       = aws_security_group.rds.id
}