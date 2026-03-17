---
name: putio-package-repo
description: Structure package repositories around a shared verify and release model. Use when creating or standardizing library/package repos across TypeScript, Swift, Kotlin, or similar ecosystems, setting up CI guardrails, defining a repo-local verify command, or enabling automatic releases on main.
---

# Putio Package Repo

Shape package repos around one boring delivery rule: every merge to `main` should already be releasable.

## Workflow

1. Inspect the repo's package type, publish target, scripts, workflows, versioning, and branch model.
2. Read [references/delivery-model.md](references/delivery-model.md).
3. If the repo is TypeScript, read [references/typescript.md](references/typescript.md).
4. For other ecosystems, keep the same verify/release shape and choose the smallest repo-native tooling that fits.
5. Prefer one repo-local `verify` entrypoint that CI calls directly.

## Guardrails

- Keep `VERIFY` as the source of truth for all guardrails.
- Run `RELEASE` only on `main`, and only after `VERIFY` passes.
- Do not duplicate complex shell logic in workflow YAML when the repo can expose a local command.
- Do not invent ecosystem-specific release tooling without a real repo or team standard behind it.
