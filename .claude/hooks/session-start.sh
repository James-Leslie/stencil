#!/bin/bash
# SessionStart hook — hydrate the project toolchain for Claude Code on the web.
#
# Cloud sessions start from a fresh clone in an ephemeral container, so the
# toolchain has to be (re)built each session. Locally this is a no-op: your
# machine is already set up once-per-machine per the gist linked in the README,
# so we exit early unless we're running remotely.
#
# Pairs with the cloud-environment setup script (see scripts/cloud-setup.sh),
# which installs mise and pre-downloads the pinned runtimes into the cached
# snapshot — making the steps below fast no-ops on subsequent sessions.
set -euo pipefail

# Local sessions are already provisioned, so don't touch anything off-cloud.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-$(pwd)}"

# mise installs to ~/.local/bin (via the setup script); make sure it's on PATH,
# and self-heal by installing it if the setup script hasn't run.
export PATH="$HOME/.local/bin:$PATH"
if ! command -v mise >/dev/null 2>&1; then
  curl -fsSL https://mise.run | sh
fi

# Install the pinned Python/Node from mise.toml. Idempotent: a no-op once the
# cached snapshot already has them. `mise trust` is required because mise won't
# read an untrusted config file.
mise trust
mise install
export PATH="$HOME/.local/share/mise/shims:$PATH"

# Python deps onto mise's interpreter (uv is pre-installed in the cloud image).
uv sync

# Frontend deps only when the frontend half is present — projects created from
# this template may delete frontend/, and the hook must skip cleanly when absent.
if [ -f frontend/package.json ]; then
  (cd frontend && pnpm install)
fi

# Persist the toolchain on PATH for the rest of the session's Bash commands.
if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  echo 'export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"' >> "$CLAUDE_ENV_FILE"
fi

echo "Toolchain ready (mise + uv$([ -f frontend/package.json ] && echo ' + pnpm'))."
