resource "aws_cloudwatch_log_group" "letsencrypt" {
  name              = "fargate-${var.service_name}-${var.environment_name}"
  retention_in_days = var.log_retention_in_days
}
