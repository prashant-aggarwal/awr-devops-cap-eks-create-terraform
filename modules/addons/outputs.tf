output "addons" {
  description = "EKS addons basic info"
  value = {
    for k, v in aws_eks_addon.main : k => {
      arn            = v.arn
      addon_name     = v.addon_name
      addon_version  = v.addon_version
    }
  }
}

output "addon_role_arn" {
  description = "ARN of the EKS addon IAM role"
  value       = aws_iam_role.addon_role.arn
}