provider "aws" {
  region = var.region
}

module "eks_cluster" {
  source = "./modules/cluster"
  cluster_name = var.cluster_name
  region       = var.region
  version      = var.k8s_version
  azs          = var.azs
}

module "nodegroups" {
  source       = "./modules/nodegroups"
  cluster_name = var.cluster_name
}

module "fargate_profiles" {
  source       = "./modules/fargate"
  cluster_name = var.cluster_name
}

module "eks_addons" {
  source       = "./modules/addons"
  cluster_name = var.cluster_name
}
