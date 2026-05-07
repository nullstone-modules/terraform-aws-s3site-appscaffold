module "logs" {
  source  = "nullstone-modules/logs/aws"
  version = "~> 0.1.0"

  name               = local.resource_name
  tags               = var.tags
  enable_log_reader  = true
  enable_get_metrics = true
  retention_in_days  = var.log_retention_in_days
}
