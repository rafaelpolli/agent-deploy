from __future__ import annotations

import operator
from typing import Any
from typing import List
from typing import Annotated
from langchain_core.messages import BaseMessage
from langgraph.graph import MessagesState


class AgentState(MessagesState):
    messages: Annotated[List[BaseMessage], operator.add]
    agent_1778290128961_response: str
    input_1778290126401_payload: dict
    agent_1778290128961_tool_calls: dict
