data "aws_iam_policy_document" "ecs_task_principal" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
data "aws_iam_policy_document" "ecs_task" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = ["arn:aws:s3:::${var.aws_s3_bucket_name}"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:PutObjectAcl",
      "s3:ListMultipartUploadParts",
      "s3:AbortMultipartUpload",
    ]
    resources = ["arn:aws:s3:::${var.aws_s3_bucket_name}/${var.environment_name}/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "route53:GetChange",
      "route53:ListHostedZones",
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "route53:ChangeResourceRecordSets",
    ]
    resources = ["arn:aws:route53:::hostedzone/${var.hosted_zone_id}"]
  }
}

resource "aws_iam_role" "ecs_task" {
  name               = "fargate-${var.service_name}-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_principal.json
}
resource "aws_iam_role_policy" "ecs_task" {
  name   = "fargate-${var.service_name}-task"
  role   = aws_iam_role.ecs_task.id
  policy = data.aws_iam_policy_document.ecs_task.json
}
