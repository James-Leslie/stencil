---
description: Scaffold a minimal FastAPI app (health endpoint + dev task + test) into this project, wired to the existing mise/uv toolchain.
disable-model-invocation: true
argument-hint: "[mount-path e.g. /api]"
---

# Add FastAPI

Scaffold a minimal, green-from-the-start FastAPI app into this project. The app
lives **inside the existing package** so it shares the venv, the gate, and the
rename ritual — it is not a parallel project.

Keep it minimal: one health endpoint, one dev task, one test. The point is a
working skeleton the user grows into, not a framework demo.

## 0. Resolve the module name

This template ships with the package named `core`, but the user is told to
rename it (see the README's "Using this template" checklist). **Do not assume
`core`.** Read the real name from `pyproject.toml` → `[tool.uv.build-backend] module-name`, and use it everywhere below as `<module>`. Confirm `src/<module>/`
exists before writing into it.

## 1. Add the dependency

```sh
uv add "fastapi[standard]"
```

`[standard]` pulls in uvicorn (the dev server), the `fastapi` CLI, and httpx
(which `TestClient` needs) — so step 4's test runs without extra deps.

## 2. Create the app

Write `src/<module>/api.py`:

```python
from fastapi import FastAPI

app = FastAPI(title="<module>")


@app.get("/health")
def health() -> dict[str, str]:
    """Liveness probe — grow this into your real routes."""
    return {"status": "ok"}
```

If the user passed a mount path in `$ARGUMENTS` (e.g. `/api`), prefix the routes
with it via an `APIRouter(prefix=...)` instead of hardcoding it on each path.
With no argument, mount at the root as shown.

## 3. Add a dev task

Add to `mise.toml` under `[tasks]`, so `mise run serve` mirrors the existing
`mise run test` / `mise run check` ergonomics:

```toml
[tasks.serve]
run = "fastapi dev src/<module>/api.py"
```

## 4. Add a test

Write `tests/test_api.py` in the same style as `tests/test_smoke.py`:

```python
from fastapi.testclient import TestClient

from <module>.api import app

client = TestClient(app)


def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}
```

## 5. Verify the gate is still green

```sh
mise run check
```

This runs the tests plus lint/format/type hooks — the same gate CI runs. Do not
report success until it passes. If `ruff` or `ty` flag the new files, fix them
rather than suppressing.

## 6. Tell the user what they got

Briefly summarize: the new files, `mise run serve` to start the dev server
(default `http://127.0.0.1:8000`, docs at `/docs`), and the `/health` route as
the seam to build on. Suggest committing as a discrete change.
