# terraform-aws-s3site-appscaffold

An OpenTofu module that scaffolds IAM and cloud resources for an AWS S3-hosted static site (deployer IAM role with S3 + optional CloudFront grants, and a CloudWatch log group via the `nullstone-modules/logs/aws` module).
