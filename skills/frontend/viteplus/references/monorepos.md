# Monorepos

Use this reference for workspace repos with multiple packages or apps.

## Target Shape

- `vp run` is the default entrypoint for workspace tasks.
- leaf packages/apps still prefer `vp check`, `vp test`, and `vp pack` where VitePlus is the real tool owner.
- avoid duplicating package-manager and cache setup in many workflows when one `setup-vp` step can cover the workspace.

## Migration Pattern

1. Inspect the workspace root scripts and task graph first.
2. Prefer migrating shared root workflows before leaf-package cleanup.
3. Keep package-local scripts boring; call them through `vp run` from the root when the repo already has workspace orchestration.
4. Migrate test imports and Vite config per package, not as one blind regex over the whole monorepo.

## Guardrails

- Do not force VitePlus onto non-frontend or non-Node packages.
- Do not replace a proven monorepo release topology unless the repo explicitly wants that change.
- Keep workspace-specific caching and dependency ordering rules if VitePlus does not fully cover them yet.
