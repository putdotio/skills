# Env Setup

Use this reference when a put.io frontend-owned repo has 1Password-backed local, live-test, build, signing, or deploy workflows. Defines the repo-side mechanics — detect, scaffold, verify — for the contract in `../putio-frontend-handbook/docs/shared-secrets.md`.

## Detect

```bash
rg -n 'op (run|inject|read|item|whoami|signin)|OP_SERVICE_ACCOUNT_TOKEN|op://|load-secrets-action' \
  AGENTS.md README.md CONTRIBUTING.md SECURITY.md docs .github Makefile package.json build.gradle.kts Package.swift .env.example .env.template scripts tooling apps Tests src 2>/dev/null

test -f .env.template && cat .env.template
test -f .envrc && cat .envrc
```

Repos with no real 1Password hits and no `.env.template` need none of the below — leave them alone.

## Standard Shape

A secrets-using repo carries four artefacts.

### Tracked `.envrc` (one line)

```bash
dotenv_if_exists .env.local
```

Identical across public and private repos. Travels with `git worktree add`. Approved per worktree with `direnv allow`. With no `.env.local` present it loads nothing, staying safe in public repos.

### Tracked `.env.template` (bare `op://` refs)

```
PUTIO_API_KEY=op://<vault>/<item>/<field>
PUTIO_TEST_USER=op://<vault>/<item>/<field>
```

Vault and item names are operational metadata — commit as-is. The same template works for `op inject` and `op run --env-file`.

### `secrets` target in the repo's native task runner

Body is identical across runners:

```bash
OP_ACCOUNT=putdotio.1password.com op inject -f -i .env.template -o .env.local
```

Bindings:

```makefile
# Makefile
.PHONY: secrets
secrets:
	OP_ACCOUNT=putdotio.1password.com op inject -f -i .env.template -o .env.local
```

```json
// package.json
{ "scripts": { "secrets": "OP_ACCOUNT=putdotio.1password.com op inject -f -i .env.template -o .env.local" } }
```

```just
# justfile
secrets:
    OP_ACCOUNT=putdotio.1password.com op inject -f -i .env.template -o .env.local
```

### `.gitignore`

```
.env
.env.*
!.env.example
!.env.template
.direnv/
```

## Targets That Need Secrets

Default verify (`build`, `test`, `lint`, `typecheck`) must work without secrets. Targets that genuinely need them either declare `secrets` as a task dependency, or wrap the command in `op run` for one-shots that should not persist secrets to disk:

```makefile
live-test: secrets
	pnpm test:live
```

```bash
OP_ACCOUNT=putdotio.1password.com op run --env-file=.env.template -- pnpm test:live
```

Do not auto-bootstrap from build/test/lint/typecheck, in CI or in agent flows.

## Verify

```bash
# .envrc is the one-liner and parses
test "$(cat .envrc)" = "dotenv_if_exists .env.local"
bash -n .envrc

# .env.local gitignored, .env.template tracked
git check-ignore -v .env.local
git check-ignore -v .env.template && echo "WRONG: .env.template must be tracked" || true

# direnv loads cleanly with no .env.local
direnv allow && direnv exec . sh -c 'echo direnv ok'

# bootstrap pre-flight
op whoami --account=putdotio.1password.com

# bootstrap produces a 0600 file with no unresolved op:// refs
<repo's secrets target>
test -f .env.local
stat -f '%Mp%Lp' .env.local | grep -q '600' && echo mode ok
grep -q 'op://' .env.local && echo "WRONG: unresolved op:// in .env.local" || echo refs ok
```

## Public Repo Notes

- Build, test, lint, typecheck must pass without `.env.local`. If any depend on secrets, move the secret-dependent flow to a separate target (`live-test`, `deploy`, `release`) that documents its requirement
- `secrets` is a committer-only target in public repos; routine contributors ignore it
- If an item title would reveal something better kept internal, rename it in 1Password rather than obscuring the `op://` reference

## Devbox And CI

Same `secrets` target works on shared devboxes and in CI when `OP_SERVICE_ACCOUNT_TOKEN` is exported. The `OP_ACCOUNT` pin is harmless once the SA token is set — `op` resolves through the token. Verify non-interactive SSH sessions actually inherit the token on the box before declaring the devbox path live.
