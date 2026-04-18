---
name: putio-frontend-docs
description: Structure and rewrite docs for frontend repositories, especially README.md, CONTRIBUTING.md, SECURITY.md, and other top-level docs. Use when creating or reorganizing frontend repo docs, clarifying user vs contributor guidance, reducing doc sprawl, or fixing stale commands, paths, and links in top-level docs.
---

# Frontend Docs

Shape frontend repo docs around a clear split between user-facing docs and contributor-facing docs.

## Workflow

1. Inspect the repository before drafting.
2. Identify the project type, user install and usage flow, contributor setup flow, and any existing docs worth linking.
3. Read [references/readme-guideline.md](references/readme-guideline.md) before picking a final shape.
4. Start from [references/contributing-template.md](references/contributing-template.md) when creating or reshaping `CONTRIBUTING.md`.
5. Start from [references/security-template.md](references/security-template.md) when creating or reshaping `SECURITY.md`.
6. Put end-user install and usage in `README.md`.
7. Put contributor environment setup, validation, and development workflow in `CONTRIBUTING.md`.
8. Ensure the repo has `CONTRIBUTING.md`, `LICENSE`, and `SECURITY.md`; keep `SECURITY.md` private-first and use `ui@put.io` for security contact.
9. Push deep implementation detail into linked docs when it starts to bloat the top-level docs.
10. When a repo uses `AGENTS.md`, keep `CLAUDE.md` beside it as a symlink to `AGENTS.md` instead of maintaining a second authored guidance file.
11. When a README uses shields badges, match the `putio-sdk-typescript` black flat style: `style=flat`, `colorA=000000`, `colorB=000000`, and `style="text-decoration:none;"` on the surrounding link.
12. In checked-in docs, use repo-relative Markdown links for local files. Reserve absolute filesystem paths for chat/UI file references, not versioned docs.
13. Verify that every claimed command, path, email address, doc link, and badge target exists.
14. If any command, path, link, or badge target is broken, fix the doc and re-verify before stopping.

Concrete shape:

```md
# README.md
- What the project is
- How to install or run it
- How to use it
- Where contributors should go next

# CONTRIBUTING.md
- Prerequisites
- Setup
- Verify/test commands
- Branch or PR workflow
```

Concrete checks:

```bash
rg -n "README|CONTRIBUTING|SECURITY|AGENTS|CLAUDE|docs/" README.md CONTRIBUTING.md SECURITY.md AGENTS.md CLAUDE.md docs/
test -e README.md && test -e CONTRIBUTING.md
test ! -e AGENTS.md || { test -L CLAUDE.md && test "$(readlink CLAUDE.md)" = "AGENTS.md"; }
```

## Guardrails

- Do not guess commands, environment variables, or deployment behavior.
- Do not duplicate long content that already lives in repo docs.
- Keep `README.md` focused on what the project is, how to install it, and how to use it.
- Keep `CONTRIBUTING.md` focused on setting up an environment to contribute, validating changes, and contributor workflow.
- Use `README.md`, `CONTRIBUTING.md`, `LICENSE`, and `SECURITY.md` as the default top-level doc set, with one responsibility per file.
- Keep recurring doc links in one canonical navigation area instead of duplicating the same reference lists across multiple files.
- Do not maintain separate authored copies of `AGENTS.md` and `CLAUDE.md`. If both are present, `CLAUDE.md` should be a symlink to `AGENTS.md`.
- When a repo uses shields badges, keep them on the flat black put.io style instead of mixing colors or badge variants.
- Do not hardcode volatile metrics such as test counts or coverage numbers.
- Do not add generic filler sections that say nothing specific about the repo.
- Do not cite or link unrelated external repos in generated docs unless the user explicitly asks for that.
- Do not leak chat-only absolute filesystem links such as `/Users/...`, `file://...`, or `vscode://...` into checked-in docs.
- Do not assume the repo provides a link-checking script or any repo-specific docs helper unless it actually exists.
- Never include user PII (names, emails, usernames, IPs, etc.) in docs, references, or examples. Mask or normalize any PII to generic placeholders (e.g., `user@example.com`, `your-username`).
- Never mention third-party applications by name in docs or references. Refer to them collectively as "ecosystem apps".
