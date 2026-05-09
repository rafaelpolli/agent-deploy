from __future__ import annotations

from langgraph.graph import END, StateGraph
from .state import AgentState

from .nodes.agent_1778290128961 import node_agent_1778290128961
from .nodes.output_1778290127750 import node_output_1778290127750


def build_graph() -> StateGraph:
    graph = StateGraph(AgentState)

    graph.add_node("node_agent_1778290128961", node_agent_1778290128961)
    graph.add_node("node_output_1778290127750", node_output_1778290127750)

    graph.set_entry_point("node_agent_1778290128961")

    graph.add_edge("node_agent_1778290128961", "node_output_1778290127750")
    graph.add_edge("node_output_1778290127750", END)

    return graph.compile()


graph = build_graph()
