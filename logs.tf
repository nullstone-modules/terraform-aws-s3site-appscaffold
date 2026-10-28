module "logs" {
  source  = "nullstone-modules/logs/aws"
  version = "~> 0.2.0"

  name               = local.resource_name
  tags               = var.tags
  enable_get_metrics = true
  retention_in_days  = var.log_retention_in_days
}
