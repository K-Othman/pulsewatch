output "certificate_arn" {
  description = "ARN of the validated certificate, for the ALB listener"
  value       = aws_acm_certificate_validation.this.certificate_arn
}

output "zone_id" {
  description = "Hosted zone ID, for the ALB alias record later"
  value       = data.aws_route53_zone.this.zone_id
}