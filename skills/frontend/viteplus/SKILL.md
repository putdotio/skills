---
name: frontend-viteplus
description: Migrate or align frontend repositories to the stock VitePlus workflow. Use when standardizing package or monorepo repos around `vp`, `voidzero-dev/setup-vp`, `vite-plus/test`, and VitePlus-native CI, test, and packaging flows.
---

# Frontend VitePlus

Use this skill to move a frontend repo closer to the stock VitePlus toolchain without blindly deleting repo-specific release or runtime logic.

## Workflow

1. Inspect the repo's current scripts, workflows, Vite config, test imports, release flow, and package manager.
2. Read [references/bootstrap.md](references/bootstrap.md) when creating a new repo or running `vp migrate`.
3. Read [references/packages.md](references/packages.md) for standalone package repos.
4. Read [references/monorepos.md](references/monorepos.md) for workspace repos.
5. Read [references/ci-cd.md](references/ci-cd.md) before changing GitHub Actions or release automation.
6. Read [references/testing.md](references/testing.md) before migrating test imports, coverage, or test commands.
7. Keep repo-specific binary, release, or packaging steps only where VitePlus does not replace them cleanly.
8. Prefer one coherent migration: scripts, workflows, and test surface should move together.
9. Verify with repo-native guardrails, then prove the important runtime surface still works.

## Guardrails

- Prefer `voidzero-dev/setup-vp@v1` plus `vp install` in CI over hand-rolled Node/Corepack setup unless the repo has a proven exception.
- Prefer `vp create` or `vp migrate` as the starting point when bootstrapping or converting a repo instead of hand-porting everything from scratch.
- Prefer `vp check`, `vp test`, and `vp pack` over direct tool binaries for day-to-day workflows.
- Prefer imports from `vite-plus` and `vite-plus/test` over direct `vite` and `vitest` imports when migrating to VitePlus.
- Use `vp pack` for libraries and executables; use `vp build` for web applications.
- Keep `pack` config in `vite.config.ts` when feasible; do not maintain parallel tsdown config unless the repo has a deliberate reason.
- Do not delete repo-specific release workflows, binary packaging, or publish steps just to look more "stock."
- If VitePlus-generated `AGENTS.md`, hooks, or editor files would overwrite better repo-specific guidance, merge the useful parts instead of replacing local instructions wholesale.
- When coverage requires `@vitest/coverage-v8`, treat mixed-version warnings as a known VitePlus caveat and verify whether the same warning reproduces in a fresh stock scaffold before calling it a repo bug.
- Update contributor docs when install, test, or verify commands change.
