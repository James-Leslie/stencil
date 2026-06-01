# Stencil

## 0. Prerequisites

This project assumes **mise**, **uv**, and **pnpm** are installed and configured on your machine
(mise manages the Python + Node runtimes, uv manages Python packages and the venv, pnpm manages
Node packages).

If you haven't set these up yet, follow the one-time machine setup:
**[Dev Environment Setup](https://gist.github.com/James-Leslie/41caf391299dee81b91bd01a8fa156f8)**.

## 1. Getting Started

From a freshly created repo:

```sh
mise install                 # install the pinned Python + Node (and prek, just)
uv sync                      # install Python deps; creates .venv on mise's Python
```
