

_AGENT_TOOLS: dict = {
    "agent_1778290128961": [],
}

def get_tools_for_agent(agent_node_id: str) -> list:
    return _AGENT_TOOLS.get(agent_node_id, [])
