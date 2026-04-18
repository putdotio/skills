---
name: putio-frontend-repos
description: Structure frontend repositories around a shared verify and delivery model. Use when standardizing package repos, app repos, or SDK repos across TypeScript, Swift, Kotlin, or similar ecosystems; setting up CI guardrails; defining a repo-local verify command; or enabling continuous publish/deploy flows on main after verify passes.
---

# Frontend Repos

Shape frontend repos around one boring delivery rule: every merge to `main` should already be publishable or deployable.

## Workflow

1. Inspect the repo's kind, delivery target, scripts, workflows, versioning, and branch model.
2. Read [references/delivery-model.md](references/delivery-model.md).
3. If the repo is TypeScript, read [references/typescript.md](references/typescript.md).
4. If the repo is an application, read [references/applications.md](references/applications.md).
5. For other ecosystems, keep the same verify/deliver shape and choose the smallest repo-native tooling that fits.
6. Prefer one repo-local `verify` entrypoint that CI calls directly.
7. Run the repo-local `verify` command locally and require a clean exit before changing delivery automation.
8. If `verify` fails locally or in CI, fix the repo-local command before changing delivery automation and rerun it until it passes.
9. Verify the publish or deploy path only after the repo-local `verify` command is stable and reproducible.

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

App-shaped example:

```yaml
- name: Verify
  run: make verify

- name: Deploy Beta
  if: github.ref == 'refs/heads/main'
  run: make deploy-beta
```

## Guardrails

- Keep `VERIFY` as the source of truth for all guardrails.
- Run delivery only on `main`, and only after `VERIFY` passes.
- Prefer GitHub Actions for orchestration; avoid adding release-only or deploy-only dependencies unless an existing repo or team standard requires them.
- Do not duplicate complex shell logic in workflow YAML when the repo can expose a local command.
- Do not invent ecosystem-specific release tooling without a real repo or team standard behind it.
- Package repos should publish continuously when releasable commits land on `main`.
- App repos should deploy continuously to the right target for that repo, such as preview, beta, TestFlight, or production.
