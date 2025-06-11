variable "region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "pa-cap-eks-cluster"
}

variable "k8s_version" {
  default = "1.32"
}

variable "azs" {
  default = ["us-east-1a", "us-east-1b"]
}
