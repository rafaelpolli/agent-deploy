variable "agent_name" {
  description = "Name of the agent (used as resource prefix)"
  type        = string
  default     = "my-agent"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "ecr_image_uri" {
  description = "ECR image URI for the AgentCore Runtime container"
  type        = string
}

variable "agentcore_model_id" {
  description = "Bedrock model ID for the agent"
  type        = string
  default     = "anthropic.claude-3-5-sonnet-20241022-v2:0"
}

variable "agentcore_inference_profile_arn" {
  description = "Cross-region inference profile ARN (takes precedence over model_id when set)"
  type        = string
  default     = ""
}

variable "enable_memory" {
  type    = bool
  default = false
}

variable "memory_ttl_seconds" {
  description = "AgentCore Memory event expiry duration in seconds"
  type        = number
  default     = 3600
}

variable "latency_alarm_threshold_ms" {
  type    = number
  default = 5000
}

variable "cloudwatch_log_retention_days" {
  type    = number
  default = 30
}
