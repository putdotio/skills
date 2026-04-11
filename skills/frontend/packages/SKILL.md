---
name: putio-frontend-packages
description: Structure package repositories around a shared verify and release model. Use when creating or standardizing library/package repos across TypeScript, Swift, Kotlin, or similar ecosystems, setting up CI guardrails, defining a repo-local verify command, or enabling automatic releases on main after verify passes.
---

# Frontend Packages

Shape package repos around one boring delivery rule: every merge to `main` should already be releasable.

## Workflow

1. Inspect the repo's package type, publish target, scripts, workflows, versioning, and branch model.
2. Read [references/delivery-model.md](references/delivery-model.md).
3. If the repo is TypeScript, read [references/typescript.md](references/typescript.md).
4. For other ecosystems, keep the same verify/release shape and choose the smallest repo-native tooling that fits.
5. Prefer one repo-local `verify` entrypoint that CI calls directly.
6. Run the repo-local `verify` command locally and require a clean exit before changing release automation.
7. If `verify` fails locally or in CI, fix the repo-local command before changing release automation and rerun it until it passes.
8. Verify the release path only after the repo-local `verify` command is stable and reproducible.

Concrete example:

```json
{
  "scripts": {
    "verify": "pnpm lint && pnpm test && pnpm build"
  }
}
```

```yaml
- name: Verify
  run: pnpm verify

- name: Release
  if: github.ref == 'refs/heads/main'
  run: pnpm release
```

## Guardrails

- Keep `VERIFY` as the source of truth for all guardrails.
- Run `RELEASE` only on `main`, and only after `VERIFY` passes.
- Prefer GitHub Actions for release orchestration; avoid adding release-only package dependencies or scripts unless an existing repo or team standard requires them.
- Do not duplicate complex shell logic in workflow YAML when the repo can expose a local command.
- Do not invent ecosystem-specific release tooling without a real repo or team standard behind it.
