variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "oidc_issuer_url" {
  description = "OIDC issuer URL for the cluster"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC provider"
  type        = string
}

variable "service_accounts" {
  description = "Service accounts with IAM roles"
  type = map(object({
    namespace = string
    policies  = list(string)
  }))
}