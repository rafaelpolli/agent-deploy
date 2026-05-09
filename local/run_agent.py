#!/usr/bin/env python
"""Local agent runner for my-agent.

Usage:
  uv run python local/run_agent.py --input '{"message": "Hello"}' [--mock-tools]
  AWS_PROFILE=dev uv run python local/run_agent.py --input '{"message": "Hello"}'

This script invokes the AgentCore entrypoint in-process. To exercise the
full HTTP server locally, run `python -m agent.runner` and POST to it.
"""
import argparse
import asyncio
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))


async def _invoke(payload: dict) -> dict:
    from agent.runner import invoke
    return await invoke(payload, {"session_id": payload.get("thread_id", "local-session")})


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True, help="JSON input payload")
    parser.add_argument("--mock-tools", action="store_true", help="Replace tool calls with mocks")
    args = parser.parse_args()

    payload = json.loads(args.input)

    if args.mock_tools:
        from local.mock_tools import patch_tools
        patch_tools()

    result = asyncio.run(_invoke(payload))
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
