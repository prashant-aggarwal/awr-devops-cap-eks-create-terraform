# Data sources
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_caller_identity" "current" {}

# VPC Module
module "vpc" {
  source = "../modules/vpc"

  cluster_name         = var.cluster_name
  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs = var.public_subnet_cidrs
}

# EKS Cluster Module
module "eks" {
  source = "../modules/eks"

  cluster_name           = var.cluster_name
  cluster_version        = var.cluster_version
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.vpc.private_subnet_ids
  service_ipv4_cidr     = var.service_ipv4_cidr
  enable_cluster_logging = var.enable_cluster_logging
  log_types             = var.log_types
}

# Node Groups Module
module "node_groups" {
  source = "../modules/node-groups"

  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  
  cluster_name     = module.eks.cluster_name
  
  depends_on = [module.eks]
}

# Fargate Profiles Module
module "fargate" {
  source = "../modules/fargate"

  cluster_name = module.eks.cluster_name
  subnet_ids   = module.vpc.private_subnet_ids
  
  fargate_profiles = var.fargate_profiles
  
  depends_on = [module.eks]
}

# EKS Addons Module
module "addons" {
  source = "../modules/addons"

  cluster_version = var.cluster_version
  addons = var.addons
  
  cluster_name    = module.eks.cluster_name
  oidc_issuer_url = module.eks.cluster_oidc_issuer_url
  
  depends_on = [module.eks, module.node_groups]
}

# Service Accounts Module
module "service_accounts" {
  source = "../modules/service-accounts"

  cluster_name           = module.eks.cluster_name
  oidc_issuer_url       = module.eks.cluster_oidc_issuer_url
  oidc_provider_arn     = module.eks.cluster_oidc_provider_arn
  service_accounts      = var.service_accounts
  
  depends_on = [module.eks]
}

terraform {
  backend "s3" {}
}