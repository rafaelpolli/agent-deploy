agent_name                      = "my-agent"
environment                     = "dev"
aws_region                      = "us-east-1"
ecr_image_uri                   = "<run 'terraform output ecr_repository_url' after first apply, then push image>"
agentcore_model_id              = "anthropic.claude-3-5-sonnet-20241022-v2:0"
agentcore_inference_profile_arn = ""
enable_memory                   = false
memory_ttl_seconds              = 3600
latency_alarm_threshold_ms      = 5000
cloudwatch_log_retention_days   = 30
# AgentCore Runtime hosts the agent container directly (no Lambda for the agent).
# Tool nodes (if any) and the API GW invoker are the only Lambdas in this stack.
