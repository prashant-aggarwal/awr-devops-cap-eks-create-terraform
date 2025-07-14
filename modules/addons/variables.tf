variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
}

variable "oidc_issuer_url" {
  description = "OIDC issuer URL for the cluster"
  type        = string
}

variable "addons" {
  description = "EKS addons configuration"
  type = any
}