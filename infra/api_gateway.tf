resource "aws_apigatewayv2_api" "agent" {
  name          = var.agent_name
  protocol_type = "HTTP"
}

# Thin invoker Lambda — bridges API Gateway HTTP requests to
# bedrock-agentcore InvokeAgentRuntime. Stateless. Sub-100ms overhead.
resource "aws_lambda_function" "agentcore_invoker" {
  function_name = "${var.agent_name}-invoker"
  role          = aws_iam_role.agentcore_invoker.arn
  runtime       = "python3.12"
  handler       = "invoker.handler"
  filename      = "${path.module}/invoker.zip"
  timeout       = 60
  memory_size   = 256

  environment {
    variables = {
      AGENT_RUNTIME_ARN = aws_bedrockagentcore_agent_runtime.agent.agent_runtime_arn
      AWS_REGION_NAME   = var.aws_region
    }
  }
}

resource "aws_iam_role" "agentcore_invoker" {
  name               = "${var.agent_name}-invoker"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

resource "aws_iam_role_policy" "agentcore_invoker" {
  role = aws_iam_role.agentcore_invoker.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["bedrock-agentcore:InvokeAgentRuntime"]
        Resource = aws_bedrockagentcore_agent_runtime.agent.agent_runtime_arn
      },
      {
        Effect   = "Allow"
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Resource = "arn:aws:logs:*:*:*"
      },
    ]
  })
}

resource "aws_apigatewayv2_integration" "agent" {
  api_id                 = aws_apigatewayv2_api.agent.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.agentcore_invoker.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "invoke" {
  api_id    = aws_apigatewayv2_api.agent.id
  route_key = "POST /invoke"
  target    = "integrations/${aws_apigatewayv2_integration.agent.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.agent.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.agentcore_invoker.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.agent.execution_arn}/*/*"
}
