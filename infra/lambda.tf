# Tool Lambdas — one per tool node, each with its own least-privilege IAM role.
# The agent itself does NOT run on Lambda; see agentcore.tf for the
# aws_bedrockagentcore_agent_runtime that hosts the agent container.
# No tool nodes in this graph — no tool Lambdas generated.\n