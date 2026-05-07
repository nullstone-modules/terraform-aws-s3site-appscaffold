output "deployer" {
  value = {
    role_arn         = aws_iam_role.deployer.arn
    session_duration = 3600
  }
  description = "IAM role with S3 deploy permissions on the bucket and (optionally) CloudFront invalidation on cdn_arns. Assumable by the principals in var.op_assumer_arns."
}

output "log_group" {
  value = {
    name = module.logs.name
    arn  = module.logs.arn
  }
  description = "CloudWatch log group provisioned for the site."
}

output "log_reader" {
  value       = module.logs.reader
  description = "An AWS User with explicit privilege to read logs from CloudWatch."
  sensitive   = true
}
