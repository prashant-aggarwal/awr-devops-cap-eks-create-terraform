variable "region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "pa-cap-eks-cluster"
}

variable "cluster_version" {
  default = "1.32"
}

variable "azs" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "s3_tfstate_bucket_name" {
  default = "pa-capstone-terraform-deployment-bucket"
}

variable "s3_tfstate_bucket_key" {
  default = "envs/dev/terraform.tfstate"
}