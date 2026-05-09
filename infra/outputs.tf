output "api_gateway_url" {
  description = "Public HTTP URL — POSTs to /invoke route the request to AgentCore Runtime."
  value       = aws_apigatewayv2_api.agent.api_endpoint
}

output "ecr_repository_url" {
  description = "ECR repository URL — push the agent container image here before deploy."
  value       = aws_ecr_repository.agent.repository_url
}

output "agentcore_runtime_arn" {
  description = "Bedrock AgentCore Runtime ARN — invoke directly via bedrock-agentcore:InvokeAgentRuntime (SigV4)."
  value       = aws_bedrockagentcore_agent_runtime.agent.agent_runtime_arn
}

output "agentcore_runtime_endpoint" {
  description = "AgentCore Runtime invoke endpoint — bypass API Gateway when using A2A or SigV4 clients."
  value       = try(aws_bedrockagentcore_agent_runtime.agent.agent_runtime_endpoint, "")
}
