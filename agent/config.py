from __future__ import annotations

import functools
import os

import boto3

AWS_REGION: str = os.environ.get("AWS_REGION", "us-east-1")
AGENT_NAME: str = os.environ.get("AGENT_NAME", "my-agent")
CHECKPOINTER_TABLE: str = os.environ.get("CHECKPOINTER_TABLE", "my-agent-sessions")
CACHE_TABLE: str = os.environ.get("CACHE_TABLE", "my-agent-cache")


@functools.lru_cache(maxsize=None)
def get_secret(secret_name: str) -> str:
    """Fetch secret from Secrets Manager. Cached in-process after first call."""
    client = boto3.client("secretsmanager", region_name=AWS_REGION)
    response = client.get_secret_value(SecretId=secret_name)
    return response["SecretString"]
