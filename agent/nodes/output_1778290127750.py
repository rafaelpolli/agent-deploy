from ..state import AgentState


def node_output_1778290127750(state: AgentState) -> dict:
    """Terminal node — writes final payload to state for the runner to read."""
    return {"final_output": state.get("agent_1778290128961_response")}
