# 设置 Windows 下默认使用 PowerShell，Mac/Linux 下默认使用 bash
set windows-shell := ["powershell.exe", "-NoProfile", "-Command"]

# 默认打印帮助信息
default:
    @just --list

# 环境准备
install:
    uv venv
    uv sync
    uv run pre-commit install

# 静态检查
check-static:
    uv run ruff check .
    uv run pyright
    uv run mypy .

# 格式化
format:
    uv run ruff check --fix .
    uv run ruff format .

# 单元测试
test:
    uv run pytest -m "not fuzz"

# 本地模拟 CI
ci: check-static test

# 跨平台安全的清理指令 (PowerShell/bash 通用)
clean:
    uv run python -c "import shutil, os; [shutil.rmtree(p, ignore_errors=True) for p in ['.venv', '.mypy_cache', '.pytest_cache', '.ruff_cache', '.pyright_cache']]"
