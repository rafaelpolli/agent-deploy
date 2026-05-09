data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# AgentCore Runtime execution role — assumed by the bedrock-agentcore service
# to run the agent container. This is the ONLY runtime role for the agent;
# there is no separate Lambda execution role for the agent itself.
data "aws_iam_policy_document" "agentcore_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["bedrock-agentcore.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "agentcore_execution" {
  name               = "${var.agent_name}-agentcore"
  assume_role_policy = data.aws_iam_policy_document.agentcore_assume.json
}

resource "aws_iam_role_policy" "agentcore_execution" {
  role   = aws_iam_role.agentcore_execution.id
  policy = data.aws_iam_policy_document.agent_policy.json
}

data "aws_iam_policy_document" "agent_policy" {
  statement {
    sid     = "Bedrock"
    actions = ["bedrock:InvokeModel", "bedrock:InvokeModelWithResponseStream"]
    # Scoped to configured model — replace * with specific model ARNs before production
    resources = ["arn:aws:bedrock:${var.aws_region}::foundation-model/*"]
  }

  statement {
    sid       = "SecretsManager"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["arn:aws:secretsmanager:${var.aws_region}:*:secret:${var.agent_name}/*"]
  }

  statement {
    sid       = "CloudWatch"
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["arn:aws:logs:*:*:*"]
  }
}
