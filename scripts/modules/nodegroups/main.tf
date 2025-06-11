module "nodegroup" {
  source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"

  cluster_name = var.cluster_name
  name         = "nodegroup-1"
  desired_size = 3
  min_size     = 3
  max_size     = 6

  instance_types = ["t3.medium"]
  capacity_type  = "SPOT"

  enable_bootstrap_user_data = true

  tags = {
    "k8s.io/cluster-autoscaler/enabled" = "true"
  }

  iam_role_additional_policies = {
    CloudWatchAgentPolicy = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
    ALBIngress            = "arn:aws:iam::aws:policy/ALBIngressControllerPolicy"
  }
}
