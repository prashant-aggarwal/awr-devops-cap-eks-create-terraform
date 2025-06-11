module "fargate_profile" {
  source = "terraform-aws-modules/eks/aws//modules/fargate-profile"

  cluster_name = var.cluster_name

  fargate_profiles = {
    on-fargate = {
      selectors = [{ namespace = "on-fargat" }]
    },
    myprofile = {
      selectors = [{ namespace = "prod", labels = { stack = "frontend" } }]
    }
  }
}
