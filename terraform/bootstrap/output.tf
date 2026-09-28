output "state_bucket_name" {
  description = "S3 bucket holding Terraform state"
  value       = aws_s3_bucket.tfstate.bucket
}

output "github_plan_role_arn" {
  description = "Role assumed by pull request plan runs"
  value       = aws_iam_role.github_plan.arn
}

output "github_apply_role_arn" {
  description = "Role assumed by apply and destroy runs on main"
  value       = aws_iam_role.github_apply.arn
}