output "target_group_arn" {
  description = "Used by the ECS web service to register tasks"
  value       = aws_lb_target_group.this.arn
}

output "alb_dns_name" {
  description = "AWS address of the ALB"
  value       = aws_lb.this.dns_name
}

output "alb_arn_suffix" {
  description = "Used by CloudWatch alarms"
  value       = aws_lb.this.arn_suffix
}