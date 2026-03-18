# Bootstrap And Migration

Use this reference when starting a new repo on VitePlus or converting an existing one.

## Stock Entry Points

- `vp create vite:monorepo`
- `vp create vite:application`
- `vp create vite:library`
- `vp create vite:generator`
- `vp migrate`

## Important Options

- `--agent <name>` writes agent instruction files during scaffolding or migration
- `--editor <name>` writes editor config files
- `--hooks` enables pre-commit hook setup
- `--no-hooks` skips hook setup
- `--no-interactive` is preferred for deterministic agent-driven runs

## Guidance

1. Use `vp create` for new repos and `vp migrate` for existing repos.
2. Prefer `vp migrate --no-interactive` when handing the conversion to an agent.
3. After migration, move any remaining tool-specific config into `vite.config.ts`.
4. Keep useful generated agent guidance, but merge it into the repo's real `AGENTS.md` instead of accepting generic VitePlus boilerplate unchanged.

## Install Surface

- Prefer `vp install` over direct package-manager commands in docs and common workflows.
- VitePlus detects the package manager from the workspace, including `packageManager`, `pnpm-workspace.yaml`, and lockfiles.
- In CI, `vp install --frozen-lockfile` is a good fit when the repo wants immutable installs.
