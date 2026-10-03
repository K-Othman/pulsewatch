variable "zone_name" {
  description = "Existing Route 53 hosted zone (not managed by Terraform)"
  type        = string
}

variable "domain_name" {
  description = "Domain the certificate is issued for"
  type        = string
}