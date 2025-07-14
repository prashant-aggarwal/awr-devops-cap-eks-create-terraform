variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for Fargate profiles"
  type        = list(string)
}

variable "fargate_profiles" {
  description = "Configuration for Fargate profiles"
  type = map(object({
    selectors = list(object({
      namespace = string
      labels    = map(string)
    }))
  }))
}