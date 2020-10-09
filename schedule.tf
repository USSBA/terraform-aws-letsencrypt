data "aws_subnet" "subnets" {
  count = length(var.subnet_ids)
  id    = var.subnet_ids[count.index]
}

resource "aws_security_group" "allow_outbound_traffic" {
  name_prefix = "${var.service_name}-${var.environment_name}"
  description = "${var.service_name} Allow outbound traffic"
  vpc_id      = data.aws_subnet.subnets[0].vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_cloudwatch_event_rule" "schedule_rule" {
  name                = "${var.service_name}-${var.environment_name}"
  schedule_expression = var.schedule_expression
  is_enabled          = true
}

resource "aws_cloudwatch_event_target" "fargate_scheduled_task" {
  rule     = aws_cloudwatch_event_rule.schedule_rule.name
  arn      = "arn:aws:ecs:${local.region}:${local.account_id}:cluster/${var.cluster_name}"
  role_arn = aws_iam_role.schedule_role.arn

  ecs_target {
    task_definition_arn = aws_ecs_task_definition.letsencrypt.arn
    task_count          = 1
    launch_type         = "FARGATE"

    network_configuration {
      subnets         = var.subnet_ids
      security_groups = [aws_security_group.allow_outbound_traffic.id]
    }
  }
}

resource "aws_iam_role_policy" "schedule_role_policy" {
  name   = "${var.service_name}-${var.environment_name}-_schedule_policy"
  role   = aws_iam_role.schedule_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecs:RunTask"
            ],
            "Resource": [
                "${aws_ecs_task_definition.letsencrypt.arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:PassRole"
            ],
            "Resource": [
                "${aws_iam_role.ecs_task.arn}",
                "${aws_iam_role.ecs_execution.arn}"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role" "schedule_role" {
  name = "${var.service_name}-${var.environment_name}_schedule_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}
