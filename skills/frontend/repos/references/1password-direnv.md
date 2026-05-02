# 1Password And Direnv

Use this reference when a put.io frontend-owned repo has 1Password-backed local, live-test, build, signing, or deploy workflows.

## Detect

Scan the repo before changing env setup:

```bash
rg -n 'op (run|inject|read|item|whoami|signin)|OP_SERVICE_ACCOUNT_TOKEN|PUTIO_1PASSWORD|op://|1Password\\.local\\.env|load-secrets-action' \
  AGENTS.md README.md CONTRIBUTING.md SECURITY.md docs .github Makefile package.json build.gradle.kts Package.swift .env.example scripts tooling apps Tests src 2>/dev/null
```

Repos with no real 1Password hits do not need `.envrc` just for uniformity.

## Standard Shape

If the repo has real hits:

- commit a secretless `.envrc` that loads the shared private env mount and optional `.env.local` dotenv overrides
- ignore `.env`, `.env.*`, and `.direnv/`, while preserving `!.env.example`
- document `direnv allow` as the per-checkout and per-worktree approval step
- treat `OP_SERVICE_ACCOUNT_TOKEN` as ambient local auth supplied by direnv, not something docs ask people to paste into shells
- keep repo-local files such as `1Password.local.env` only for vault/item routing or other non-secret selector defaults
- remove agent-facing personal `op signin`, `op whoami`, or "unlock 1Password" fallbacks unless the repo explicitly needs an interactive human account flow

## Verify

```bash
bash -n .envrc
git check-ignore -v .envrc || true
git check-ignore -v .env.local .env .env.test .direnv/foo .env.example 2>/dev/null || true
direnv allow
direnv exec . sh -c 'printf "OP=%s\n" "${OP_SERVICE_ACCOUNT_TOKEN:+present}"'
```
