"""AgentCore Observability bootstrap.

When this module is imported inside an AgentCore Runtime container, the SDK
auto-instruments LangGraph/LangChain calls and ships OTEL traces + GenAI
spans to Amazon CloudWatch GenAI Observability. No external SaaS required.
"""
import os

from bedrock_agentcore.observability import configure as _configure_observability

_AGENT_NAME = os.environ.get("AGENT_NAME", "agent")

_configure_observability(
    service_name=_AGENT_NAME,
    enable_genai_spans=True,
    enable_langchain_instrumentation=True,
)

import json
import logging

import boto3

_log = logging.getLogger(_AGENT_NAME)
_cw = boto3.client("cloudwatch", region_name=os.environ.get("AWS_REGION", "us-east-1"))


def emit_metric(name: str, value: float, unit: str = "Milliseconds") -> None:
    """Emit a custom CloudWatch metric. Never raises — observability must not break the agent."""
    try:
        _cw.put_metric_data(
            Namespace=f"AgentsPlatform/{_AGENT_NAME}",
            MetricData=[{
                "MetricName": name,
                "Value": value,
                "Unit": unit,
                "Dimensions": [{"Name": "AgentName", "Value": _AGENT_NAME}],
            }],
        )
    except Exception:
        pass


def log_event(level: str, event: str, **fields) -> None:
    """Emit a structured CloudWatch log line."""
    payload = {"event": event, "agent": _AGENT_NAME, **fields}
    getattr(_log, level.lower(), _log.info)(json.dumps(payload))
