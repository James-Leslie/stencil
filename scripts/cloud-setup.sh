#!/bin/bash
# Cloud setup script for Claude Code on the web — REFERENCE COPY.
#
# Setup scripts live in the cloud environment config (web UI: environment
# settings -> "Setup script"), not in the repo. This file exists so the script
# is version-controlled and reviewable; paste its contents into that field.
#
# It runs once per environment, before Claude launches. Its filesystem changes
# are snapshotted and cached (~7-day expiry), so the heavy downloads here happen
# once and later sessions start fast — the cache step is then skipped.
#
# Pairs with .claude/hooks/session-start.sh, which re-runs the cheap per-session
# steps (uv sync / pnpm install) against this warm cache on every session.
#
# Note: installs need network access. mise downloads runtimes from GitHub and
# the installer from mise.run, so the environment's network allowlist must reach
# those in addition to the default package registries (PyPI, npm).
set -euo pipefail

cd "${CLAUDE_PROJECT_DIR:-$(pwd)}"

# mise is the one toolchain piece not in the cloud base image; install it.
curl -fsSL https://mise.run | sh
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"

# Pre-download the pinned Python/Node so they land in the cached snapshot.
if [ -f mise.toml ]; then
  mise trust
  mise install
fi

# Warm the uv / pnpm caches so the SessionStart hook's installs are fast.
uv sync || true
if [ -f frontend/package.json ]; then
  (cd frontend && pnpm install) || true
fi
