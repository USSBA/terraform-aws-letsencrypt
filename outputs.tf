output "letsencrypt_ecs_task" {
  value = aws_ecs_task_definition.letsencrypt
}

output "letsencrypt_schedule_sg" {
  value = aws_security_group.allow_outbound_traffic
}
