output "service_account_roles" {
  description = "Service account IAM roles"
  value = {
    for k, v in aws_iam_role.service_account : k => {
      arn  = v.arn
      name = v.name
    }
  }
}