from langchain_aws import ChatBedrock
from langgraph.prebuilt import create_react_agent

from ..state import AgentState
from ..tools import get_tools_for_agent

_model = ChatBedrock(
    model_id="anthropic.claude-3-5-sonnet-20241022-v2:0",
    model_kwargs={"temperature": 0.7, "max_tokens": 4096},
    streaming=False,
)
_agent = create_react_agent(
    _model,
    get_tools_for_agent("agent_1778290128961"),
    prompt="You are a helpful AI assistant.",
)


async def node_agent_1778290128961(state: AgentState) -> dict:
    result = await _agent.ainvoke({"messages": state["messages"]})
    messages = result["messages"]
    return {
        "messages": messages,
        "agent_1778290128961_response": messages[-1].content if messages else "",
        "agent_1778290128961_tool_calls": [
            {"name": m.name, "args": m.additional_kwargs}
            for m in messages if hasattr(m, "name") and m.name
        ],
    }
