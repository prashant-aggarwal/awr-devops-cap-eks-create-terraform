output "fargate_profiles" {
  description = "EKS Fargate profiles information"
  value = {
    for k, v in aws_eks_fargate_profile.main : k => {
      arn    = v.arn
      status = v.status
    }
  }
}

output "fargate_profile_role_arn" {
  description = "ARN of the EKS Fargate profile IAM role"
  value       = aws_iam_role.fargate_profile.arn
}