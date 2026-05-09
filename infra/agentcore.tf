# Amazon Bedrock AgentCore Runtime — serverless managed agent execution.
# Hosts the agent container directly (no Lambda). Provides:
#   - A2A protocol invocation
#   - 8-hour managed sessions (replaces LangGraph DynamoDB checkpointer)
#   - Auto-scaling and request streaming
#   - Built-in CloudWatch GenAI Observability (replaces LangSmith)
# Requires aws provider >= 5.x with AgentCore feature flag enabled.

resource "aws_bedrockagentcore_agent_runtime" "agent" {
  agent_runtime_name = var.agent_name

  agent_runtime_artifact {
    container_configuration {
      container_uri = var.ecr_image_uri
    }
  }

  network_configuration {
    network_mode = "PUBLIC"
  }

  protocol_configuration {
    server_protocol = "HTTP"
  }

  environment_variables = {
    AWS_REGION  = var.aws_region
    AGENT_NAME  = var.agent_name
    CACHE_TABLE = "${var.agent_name}-cache"
    MEMORY_ID   = try(aws_bedrockagentcore_memory.agent.memory_id, "")
    GATEWAY_ID  = try(aws_bedrockagentcore_gateway.agent.gateway_id, "")
  }

  role_arn = aws_iam_role.agentcore_execution.arn
}
