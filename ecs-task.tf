resource "aws_ecs_task_definition" "letsencrypt" {
  family = "${var.service_name}-${var.environment_name}"
  container_definitions = jsonencode(
    [
      {
        name      = "${var.service_name}-${var.environment_name}"
        image     = var.container_name
        essential = true
        cpu       = var.container_cpu
        memory    = var.container_memory
        environment = [
          {
            name  = "AWS_ENVIRONMENT"
            value = var.environment_name
          },
          {
            name  = "CERT_BUCKET_NAME"
            value = var.aws_s3_bucket_name
          },
          {
            name  = "CERT_BUCKET_PATH"
            value = "/${var.environment_name}/"
          },
          {
            name  = "CERT_REGISTRATION_EMAIL"
            value = var.registration_email
          },
          {
            name  = "CERT_REGISTER_WILDCARD"
            value = tostring(var.registration_wildcard)
          },
          {
            name  = "CERT_HOSTNAME"
            value = var.cert_hostname
          },
          {
            name  = "SNS_TOPIC_ARN"
            value = var.sns_topic_arn
          },
          {
            name  = "DRY_RUN"
            value = tostring(var.dry_run)
          },
        ]
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = aws_cloudwatch_log_group.letsencrypt.name
            awslogs-region        = local.region
            awslogs-stream-prefix = var.log_stream_prefix
          }
        }
      }
  ])
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn
  network_mode             = "awsvpc"
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  requires_compatibilities = ["FARGATE"]
}
