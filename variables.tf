# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  REQUIRED
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
variable "service_name" {
  type        = string
  description = "A unique name for Letsencrypt Fargate service."
}
variable "environment_name" {
  type        = string
  description = "Name of your environment"
}
variable "aws_s3_bucket_name" {
  type        = string
  description = "The name of the bucket where certs will be backed up."
}
variable "registration_email" {
  type        = string
  description = "The email address under which the LetsEncrypt certificate will be created."
}
variable "cert_hostname" {
  type        = string
  description = "The hostname to be registered. Do not include wildcard"
}
variable "hosted_zone_id" {
  type        = string
  description = "Route53 Hosted Zone ID"
}
variable "cluster_name" {
  type        = string
  description = "The name of the ECS cluster where the fargate task should run."
}
variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet id's that the task can run on"
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  OPTIONAL
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
variable "container_name" {
  type        = string
  description = "Letsencrypt Docker Image"
  default     = "public.ecr.aws/ussba/sba-certificate-renewal:latest"
}
variable "container_cpu" {
  type        = number
  description = "How much CPU should be reserved for the container (in aws cpu-units)"
  default     = 256
}
variable "container_memory" {
  type        = number
  description = "How much Memory should be reserved for the container (in MB)"
  default     = 512
}
variable "dry_run" {
  type        = bool
  description = "Enable or disable dry run of renewal process"
  default     = false
}
variable "log_stream_prefix" {
  type        = string
  description = "Name of the stream prefix to be used in the Cloudwatch log group"
  default     = "letsencrypt"
}
variable "log_retention_in_days" {
  type        = string
  description = "The number of days you want to retain log events in the log group"
  default     = "60"
}
variable "registration_wildcard" {
  type        = bool
  description = "Whether or not a wildcard certificate should be requested."
  default     = true
}
variable "sns_topic_arn" {
  type        = string
  description = "What SNS Topic ARN should be used for notifying."
  default     = ""
}
variable "schedule_expression" {
  type        = string
  description = "How often Cloudwatch Events should kick off the renewal task. Recommended to run at least every 30 days."
  default     = "rate(7 days)"
}
