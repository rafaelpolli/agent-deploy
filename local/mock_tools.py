"""Mock tool implementations for local testing without AWS."""
import importlib
from unittest.mock import MagicMock


def monkeypatch_module(module_path: str, fn_name: str, replacement):
    try:
        mod = importlib.import_module(module_path)
        mock = MagicMock(side_effect=replacement)
        mock.invoke = replacement
        setattr(mod, fn_name, mock)
    except ImportError:
        pass


def patch_tools():
    pass
