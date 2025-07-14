# Fargate Profile IAM Role
resource "aws_iam_role" "fargate_profile" {
  name = "${var.cluster_name}-fargate-profile-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks-fargate-pods.amazonaws.com"
        }
      }
    ]
  })
}

# Attach required policies to Fargate profile role
resource "aws_iam_role_policy_attachment" "fargate_profile_AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate_profile.name
}

# EKS Fargate Profiles
resource "aws_eks_fargate_profile" "main" {
  for_each = var.fargate_profiles

  cluster_name           = var.cluster_name
  fargate_profile_name   = each.key
  pod_execution_role_arn = aws_iam_role.fargate_profile.arn
  subnet_ids             = var.subnet_ids

  dynamic "selector" {
    for_each = each.value.selectors
    content {
      namespace = selector.value.namespace
      labels    = selector.value.labels
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.fargate_profile_AmazonEKSFargatePodExecutionRolePolicy
  ]

  tags = {
    Name = "${var.cluster_name}-${each.key}"
  }
}