---
name: putio-frontend-repos
description: Structure frontend repositories around a shared verify and delivery model. Use when standardizing package repos, app repos, or SDK repos across TypeScript, Swift, Kotlin, or similar ecosystems; setting up CI guardrails; defining a repo-local verify command; or enabling continuous publish/deploy flows on main after verify passes.
---

# Frontend Repos

Use one delivery rule: every merge to `main` should already be publishable or deployable.

## Workflow

1. Inspect the repo and capture a short summary before editing: repo kind, verify entrypoint, delivery target, versioning tool, and template gaps. Check files like `package.json`, `Makefile`, `.github/workflows/*`, `.github/pull_request_template.md`, `.github/ISSUE_TEMPLATE/*`, and release config.
2. Read [references/delivery-model.md](references/delivery-model.md).
3. If the repo is TypeScript, read [references/typescript.md](references/typescript.md).
4. If the repo is an application, read [references/applications.md](references/applications.md).
5. Prefer one repo-local `verify` entrypoint that CI calls directly.
6. Run the repo-local `verify` command locally before changing delivery automation. If it fails, fix that command first and rerun it until it passes.
7. If the repo uses semantic-release or release commits, configure the plugins and commit identity explicitly using the delivery-model reference.
8. Verify the publish or deploy path only after the repo-local `verify` command is stable and reproducible.

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
- Prefer GitHub Actions for orchestration and repo-local commands as the canonical home for build, test, and deliver logic.
- Do not invent ecosystem-specific release tooling without a real repo or team standard behind it.
- Keep package repos continuously publishable and app repos continuously deployable from `main`.
- GitHub-facing repos should carry a useful pull request template and issue templates when the review or triage flow benefits from them.
