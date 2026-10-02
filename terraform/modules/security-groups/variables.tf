variable "name" {
  description = "Name prefix for all security groups"
  type        = string
}

variable "vpc_id" {
  description = "VPC the security groups belong to"
  type        = string
}

variable "app_port" {
  description = "Port the web container listens on"
  type        = number
  default     = 3000
}

variable "db_port" {
  description = "Port the database listens on"
  type        = number
  default     = 5432
}