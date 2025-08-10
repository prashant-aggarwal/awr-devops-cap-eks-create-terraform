variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the node groups"
  type        = list(string)
}

variable "node_groups" {
  description = "Configuration for EKS node groups"
  type = map(object({
    instance_types     = list(string)
    capacity_type      = string
    min_size          = number
    max_size          = number
    desired_size      = number
    volume_encrypted  = bool
    ami_type          = string
    disk_size         = number
  }))
}

variable "ssh_key_name" {
  description = "EC2 Key Pair name for SSH access to nodes"
  type        = string
  default     = null
}