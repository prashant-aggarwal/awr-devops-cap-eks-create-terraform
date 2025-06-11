module "eks_addons" {
  source       = "terraform-aws-modules/eks/aws//modules/eks-managed-addons"
  cluster_name = var.cluster_name

  addons = {
    vpc-cni = {
      addon_version     = "latest"
      resolve_conflicts = "OVERWRITE"
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
          ENABLE_POD_ENI = "true"
          POD_SECURITY_GROUP_ENFORCING_MODE = "standard"
        },
        enableNetworkPolicy = "true",
        nodeAgent = {
          enablePolicyEventLogs = "true"
        }
      })
    },
    coredns   = { addon_version = "latest" },
    kube-proxy = { addon_version = "latest" },
    aws-ebs-csi-driver = { addon_version = "latest" },
    amazon-cloudwatch-observability = { addon_version = "latest" }
  }
}
