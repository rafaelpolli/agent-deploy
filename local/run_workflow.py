#!/usr/bin/env python
"""Local workflow runner for my-agent.

Usage:
  uv run python local/run_workflow.py --input-file local/sample_input.json
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
    parser.add_argument("--input-file", required=True)
    args = parser.parse_args()

    with open(args.input_file) as f:
        payload = json.load(f)

    result = asyncio.run(_invoke(payload))
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
