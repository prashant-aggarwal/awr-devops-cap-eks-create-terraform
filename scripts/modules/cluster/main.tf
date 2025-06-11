module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 20.0"
  cluster_name    = var.cluster_name
  cluster_version = var.version
  subnet_ids      = data.aws_subnets.private.ids
  vpc_id          = data.aws_vpc.selected.id

  enable_irsa = true

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  availability_zones              = var.azs
}
