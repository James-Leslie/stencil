# Stencil

## 0. Prerequisites

This project assumes **mise**, **uv**, and **pnpm** are installed and configured on your machine
(mise manages the Python + Node runtimes, uv manages Python packages and the venv, pnpm manages
Node packages).

If you haven't set these up yet, follow the one-time machine setup:
**[Dev Environment Setup](https://gist.github.com/James-Leslie/41caf391299dee81b91bd01a8fa156f8)**.

## 1. Getting Started

From a freshly created repo:

Install everything listed in `mise.toml`:
```sh
mise install
```

This template intentionally pins "latest" versions for everything, meaning you'll always start each new project with the latest versions.

Once you've initialised a new project, it's a good idea to then freeze the versions:
```sh
mise use python --pin
```

Now, setup your Python environment using uv:
```
uv sync
```

(Do once) Install prek’s Git shim integration:
```sh
prek install
```
