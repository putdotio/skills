# Packages

Use this reference for standalone frontend package repositories.

## Target Shape

- `package.json` scripts prefer:
  - `build: vp pack`
  - `check: vp check .`
  - `test: vp test`
- `verify` should call the repo's real delivery gate and can still include repo-specific extras.
- `vite.config.ts` owns the `pack` block instead of a separate `tsdown.config.ts` where possible.
- `pnpm` repos should add overrides for VitePlus-wrapped `vite` and `vitest`.

## Migration Pattern

1. Replace direct build/test commands with `vp` commands.
2. Keep repo-specific commands like `build:sea`, smoke tests, or publishing helpers as `vp run <script>` consumers where helpful.
3. Move pack config into `vite.config.ts` if the repo still carries a separate tsdown config.
4. If the repo exposes a `verify` command, keep that as the top-level contract.

## Good Reasons To Diverge

- standalone binary packaging
- non-standard publish flows
- platform-specific asset generation
- SDK/codegen/bootstrap steps that VitePlus does not replace
