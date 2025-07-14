output "addons" {
  description = "EKS addons information"
  value = {
    for k, v in aws_eks_addon.main : k => {
      arn    = v.arn
      status = v.addon_status
    }
  }
}

output "addon_role_arn" {
  description = "ARN of the EKS addon IAM role"
  value       = aws_iam_role.addon_role.arn
}