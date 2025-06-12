module "eks_cluster" {
  source = "../modules"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  node_group_name = "default"
  namespace       = "dev"
}

terraform {
  backend "s3" {
    bucket         = var.s3_tfstate_bucket_name
    key            = var.s3_tfstate_bucket_key
    region         = var.region
    encrypt        = true
  }
}