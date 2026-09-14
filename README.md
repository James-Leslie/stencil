# Stencil

A project template: **FastAPI** and **Svelte 5**, deployed together so `/api`
and the app share an origin. No deployment platform is assumed.

- `backend/`: FastAPI, packaged by [uv], type-checked by `ty`, linted by ruff.
- `web/`: Svelte 5 + Vite + TypeScript, on [pnpm], formatted by Prettier.

Every tool is pinned in `mise.toml`, so a clone, a CI run and a new machine all
resolve the same toolchain. [prek] runs the hooks on commit and GitHub Actions
runs the same checks on the same pinned versions.

## 0. Prerequisites

Just [mise]. It installs and manages everything else this project needs:
Python, uv, node, pnpm and prek.

If you haven't set up mise yet, follow the one-time machine setup:
**[Dev Environment Setup](https://gist.github.com/James-Leslie/41caf391299dee81b91bd01a8fa156f8)**.

## 1. Getting started

Create a new repo from this template with the GitHub CLI:

```sh
gh repo create my-project --template James-Leslie/stencil --private --clone
```

Then, from the new repo:

```sh
mise trust
mise install
```

That's the whole setup. `mise install` installs the pinned tools, and its
`postinstall` hook does the rest: `prek install` wires up the git hooks and
`mise deps install` installs both services' dependencies (uv in `backend/`,
pnpm in `web/`).

Secrets are not in the repo. Copy `.env.example` to `.env` and fill it in; mise
loads it for both services. `.env.local` is loaded on top, for machine-specific
overrides or values pulled from a host's CLI.

## 2. Making it yours

- [ ] Rename the Python package: `[project].name` in `backend/pyproject.toml`
  (currently `core`), the `src/core/` directory, and the `core.server:app`
  entrypoints in `backend/pyproject.toml` and `backend/server.py`.
- [ ] Set `[project].description` in `backend/pyproject.toml`.
- [ ] Set the `<title>` in `web/index.html` and swap `web/public/favicon.svg`.
- [ ] Rename `.claude/skills/stencil-lsp/` and its `name` in `plugin.json`.
- [ ] Update this README, `CLAUDE.md`, and the two service `CLAUDE.md` files.
- [ ] Choose a license. `LICENSE` ships as MIT; replace it if you want
  something else.
- [ ] Freshen the pins: `mise up`, then `uv sync -U` and `pnpm up --latest`.
- [ ] Run `mise run check` and `prek run --all-files` to confirm it's green.

## 3. Everyday commands

```sh
mise dev      # both dev servers
mise api      # FastAPI alone, on :8000
mise web      # Vite alone, on :5173
mise check    # type-check both services
mise build    # production build of the web app

uv add <pkg>              # backend runtime dependency (run in backend/)
pnpm add <pkg>            # web dependency (run in web/)
mise use --pin <tool>@latest   # add or bump a mise-managed tool
```

Vite proxies `/api` to the backend in dev, so the two services share an origin
and a session cookie keeps working. Reproduce that in production with whatever
your host offers: `web/dist` served as static files, `core.server:app` run as an
ASGI app, and `/api` routed to it.

## 4. What runs on commit

`prek` discovers three configs and runs each with its own directory as the
working directory:

| Config              | Hooks                                                   |
| ------------------- | ------------------------------------------------------- |
| `prek.toml`         | whitespace and EOF fixers, large-file guard, `mdformat` |
| `backend/prek.toml` | `ruff` lint + format, `ty` type check, agent-skill sync |
| `web/prek.toml`     | `prettier`                                              |

CI runs the same hooks with `prek run --all-files`, so a green local commit is a
green CI run.

## 5. Agent tooling

- `CLAUDE.md` at the root and in each service carries the conventions.
- `.claude/skills/stencil-lsp/` points Claude at the same language servers CI
  uses: `ty` for Python, `svelteserver` and `typescript-language-server` for the
  web app.
- Svelte skills are vendored in `.agents/skills/` and symlinked into
  `.claude/skills/`, tracked by `skills-lock.json`.
- The `library-skills` hook in `backend/prek.toml` syncs skills shipped by
  installed Python packages (FastAPI ships one) whenever dependencies change.
- `.claude/hooks/session-start.sh` rebuilds the toolchain in Claude Code cloud
  sessions, which start from a fresh clone each time. It's a no-op locally.

[mise]: https://mise.jdx.dev
[pnpm]: https://pnpm.io
[prek]: https://prek.j178.dev
[uv]: https://docs.astral.sh/uv/
