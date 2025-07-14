# EKS Addons
resource "aws_eks_addon" "main" {
  for_each = var.addons

  cluster_name             = var.cluster_name
  addon_name               = each.key
  addon_version            = each.value.version == "latest" ? null : each.value.version
  configuration_values     = each.value.configuration_values != "" ? jsonencode(each.value.configuration_values) : null
  resolve_conflicts_on_create = each.value.resolve_conflicts_on_create
  resolve_conflicts_on_update = each.value.resolve_conflicts_on_update

  depends_on = [
    aws_iam_role.addon_role
  ]

  tags = {
    Name = "${var.cluster_name}-${each.key}"
  }
}

# IAM Role for EKS Addons (if needed)
resource "aws_iam_role" "addon_role" {
  name = "${var.cluster_name}-addon-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policies for EBS CSI Driver
resource "aws_iam_role_policy_attachment" "addon_ebs_csi_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.addon_role.name
}

# Custom policy for VPC CNI
resource "aws_iam_policy" "vpc_cni_policy" {
  name        = "${var.cluster_name}-vpc-cni-policy"
  description = "Policy for VPC CNI addon"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:AttachNetworkInterface",
          "ec2:DetachNetworkInterface",
          "ec2:ModifyNetworkInterfaceAttribute",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeSecurityGroups",
          "ec2:CreateTags",
          "ec2:DeleteTags",
          "ec2:DescribeTags"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "addon_vpc_cni_policy" {
  policy_arn = aws_iam_policy.vpc_cni_policy.arn
  role       = aws_iam_role.addon_role.name
}