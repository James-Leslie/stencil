# Stencil

A batteries-included Python project template. It ships a modern toolchain wired
together so a new project is green from the first commit:

- **[mise]** — manages the Python (and, later, Node) runtimes.
- **[uv]** — manages Python packages and the virtualenv.
- **[prek]** — runs the git hooks (ruff lint + format, `ty` type checking).
- **GitHub Actions** — runs the same gate in CI (`mise run check`).
- **Claude Code** — a `SessionStart` hook hydrates the toolchain in cloud sessions.

It's Python-first today and **frontend-ready**: the `.gitignore` and the cloud
session hook already account for a `frontend/` (SvelteKit + pnpm) half, so adding
one later activates automatically — see [Adding a frontend](#5-adding-a-frontend).

## 0. Prerequisites

This project assumes **mise** and **uv** are installed and configured on your
machine (mise manages the language runtimes, uv manages Python packages and the
venv). **pnpm** is only needed once you add a frontend — skip it for now.

If you haven't set these up yet, follow the one-time machine setup:
**[Dev Environment Setup](https://gist.github.com/James-Leslie/41caf391299dee81b91bd01a8fa156f8)**.

## 1. Getting Started

From a freshly created repo, install everything pinned in `mise.toml`:

```sh
mise cache clear   # avoid resolving "latest" against a stale version cache
mise install
```

This template intentionally pins `"latest"` for everything, so each new project
starts on the newest runtimes. Once initialised, freeze the version:

```sh
mise use python --pin
```

Set up the Python environment with uv:

```sh
uv sync
```

Install prek's git hook (once per clone):

```sh
prek install
```

## 2. Using this template

After creating a repo from Stencil, make it yours:

- [ ] Rename the package in `pyproject.toml`: set `[project].name` and
  `[tool.uv.build-backend].module-name` (currently `example-python-project`
  / `core`).
- [ ] Rename `src/core/` to match the new `module-name`, and update imports in
  `tests/`.
- [ ] Set `[project].description` (currently a placeholder).
- [ ] Update this README's title and intro.
- [ ] Choose a license — `LICENSE` ships as MIT; replace it if you want
  something else.
- [ ] Pin the runtime: `mise use python --pin`.
- [ ] Run the gate to confirm everything is green: `mise run check`.

## 3. Everyday commands

```sh
mise run test     # run the test suite (pytest)
mise run check    # run the full gate: tests + all prek hooks (lint, format, types)
uv add <pkg>      # add a runtime dependency
uv add --dev <pkg>  # add a dev dependency
uv sync           # reconcile the venv with uv.lock
```

`mise run check` is the single source of truth for the gate — CI runs the exact
same command, so a green local run means a green CI run.

## 4. What runs on commit

`prek` runs on every commit (see `prek.toml`): whitespace/EOF fixers, `ruff`
lint + format, `mdformat` (Markdown formatting), and `uv check` (type checking
via `ty`).

## 5. Adding a frontend

The template is frontend-ready: `.gitignore` already ignores `node_modules/`,
`.svelte-kit/`, and `frontend/build/`, and `.claude/hooks/session-start.sh`
installs frontend deps when `frontend/package.json` exists. To add one:

1. Install **pnpm** (see the dev environment gist above).
2. Scaffold a SvelteKit app into `frontend/`.
3. The cloud session hook will pick it up automatically on the next session.

[mise]: https://mise.jdx.dev
[prek]: https://prek.j178.dev
[uv]: https://docs.astral.sh/uv/
