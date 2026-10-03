variable "name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "force_delete" {
  description = "Allow deleting the repository even if it still contains images"
  type        = bool
  default     = false
}

variable "max_image_count" {
  description = "Number of images to keep before older ones are expired"
  type        = number
  default     = 10
}