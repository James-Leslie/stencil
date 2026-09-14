#!/bin/bash
# SessionStart hook: hydrate the project toolchain for Claude Code on the web.
#
# Cloud sessions start from a fresh clone in an ephemeral container, so the
# toolchain has to be (re)built each session. Locally this is a no-op: your
# machine is already set up once-per-machine per the gist linked in the README,
# so we exit early unless we're running remotely.
#
# Optional speed-up: configure a setup script in the cloud environment (web UI)
# that installs mise and pre-downloads the pinned runtimes into the cached
# snapshot. This hook self-heals without one (it installs mise below), just
# more slowly on the first, uncached session.
set -euo pipefail

# Local sessions are already provisioned, so don't touch anything off-cloud.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-$(pwd)}"

# Ensure mise is on PATH, installing it if the cloud setup script hasn't.
export PATH="$HOME/.local/bin:$PATH"
if ! command -v mise >/dev/null 2>&1; then
  curl -fsSL https://mise.run | sh
fi

# mise.toml pins every tool this project needs, and its postinstall hook
# finishes the job: `prek install` for the git hooks, `mise deps install` for
# both services' dependencies (uv in backend/, pnpm in web/). Idempotent, so
# this is a no-op once the cached snapshot already has them. `mise trust` is
# required because mise won't read an untrusted config file.
mise trust
mise install

# Persist the toolchain on PATH for the rest of the session's Bash commands,
# through $CLAUDE_ENV_FILE (the supported, non-interactive-safe channel) rather
# than ~/.bashrc, which is guarded out of non-interactive shells. --shims is
# the non-interactive-safe activation: plain PATH exports, no prompt hook.
if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  mise activate bash --shims >> "$CLAUDE_ENV_FILE"
fi

echo "Toolchain ready (mise + uv + pnpm)."
