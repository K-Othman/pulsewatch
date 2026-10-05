variable "name" {
  description = "Prefix for resource names"
  type        = string
}

variable "environment" {
  description = "Environment tag, e.g. production"
  type        = string
}

variable "vpc_id" {
  description = "VPC the target group lives in"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnets the ALB sits in"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security group attached to the ALB"
  type        = string
}

variable "certificate_arn" {
  description = "ACM certificate for the HTTPS listener"
  type        = string
}

variable "zone_id" {
  description = "Route 53 hosted zone for the alias record"
  type        = string
}

variable "domain_name" {
  description = "Domain that points at the ALB"
  type        = string
}

variable "container_port" {
  description = "Port the app listens on inside the container"
  type        = number
  default     = 3000
}

variable "health_check_path" {
  description = "Path the ALB checks on each target"
  type        = string
  default     = "/health"
}