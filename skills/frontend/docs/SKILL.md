---
name: putio-frontend-docs
description: Structure and rewrite docs for frontend repositories, especially README.md, CONTRIBUTING.md, SECURITY.md, and other top-level docs. Use when creating or reorganizing frontend repo docs, clarifying user vs contributor guidance, or reducing doc sprawl.
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
10. Verify that every claimed command, path, email address, and doc link exists.

## Guardrails

- Do not guess commands, environment variables, or deployment behavior.
- Do not duplicate long content that already lives in repo docs.
- Keep `README.md` focused on what the project is, how to install it, and how to use it.
- Keep `CONTRIBUTING.md` focused on setting up an environment to contribute, validating changes, and contributor workflow.
- Use `README.md`, `CONTRIBUTING.md`, `LICENSE`, and `SECURITY.md` as the default top-level doc set, with one responsibility per file.
- Keep recurring doc links in one canonical navigation area instead of duplicating the same reference lists across multiple files.
- Keep `SECURITY.md` private-first: ask reporters not to open public issues for vulnerabilities and direct them to `ui@put.io`.
- Do not hardcode volatile metrics such as test counts or coverage numbers.
- Do not add generic filler sections that say nothing specific about the repo.
- Do not cite or link unrelated external repos in generated docs unless the user explicitly asks for that.
