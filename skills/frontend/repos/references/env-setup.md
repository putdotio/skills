# Env Setup

Use this reference when a put.io frontend-owned repo has 1Password-backed local, live-test, build, signing, or deploy workflows. Defines the repo-side mechanics — detect, scaffold, verify — and is self-contained: external contributors and future agents can apply it without access to internal operator docs.

**Out of scope**: repos with native non-task-runner build systems (e.g. Xcode + Fastlane), repos that *hold* signing material consumed by tools like `match`, and repos whose `.env`/`.env.example` carry plain device or runtime credentials rather than 1Password references. Those follow their repo-local setup; operators maintain the current carve-out list privately.

## Detect

```bash
rg -n 'op (run|inject|read|item|whoami|signin)|OP_SERVICE_ACCOUNT_TOKEN|op://|load-secrets-action' \
  AGENTS.md README.md CONTRIBUTING.md SECURITY.md docs .github Makefile package.json build.gradle.kts Package.swift .env.example scripts tooling apps Tests src 2>/dev/null

test -f .env.example && cat .env.example
test -f .envrc && cat .envrc
```

Repos with no real 1Password hits and no `.env.example` need none of the below — leave them alone.

If `.envrc` already exists with content beyond the one-liner (e.g. a multi-line `dotenv_if_regular_file_or_fifo_exists` block, or `use mise`/runtime pins/PATH manipulation), confirm with the operator before overwriting — those carry meaning. If `.env.example` already exists with bare-key placeholders for non-1Password values (e.g. local device creds), preserve those entries when migrating to `op://` references — do not silently replace mixed content.

## Standard Shape

A secrets-using repo carries four artefacts.

### Tracked `.envrc` (one line)

```bash
dotenv_if_exists .env.local
```

Identical across public and private repos. Travels with `git worktree add`. Approved per worktree with `direnv allow`. With no `.env.local` present it loads nothing, staying safe in public repos.

### Tracked `.env.example` (bare `op://` refs)

```
PUTIO_API_KEY=op://<vault>/<item>/<field>
PUTIO_TEST_USER=op://<vault>/<item>/<field>
```

Vault and item names are operational metadata — commit as-is. The same template works for `op inject` and `op run --env-file`.

### `secrets` target in the repo's native task runner

Body is identical across runners:

```bash
OP_ACCOUNT=putdotio.1password.com op inject -f -i .env.example -o .env.local
```

Bindings:

```makefile
# Makefile
.PHONY: secrets
secrets:
	OP_ACCOUNT=putdotio.1password.com op inject -f -i .env.example -o .env.local
```

```json
// package.json
{ "scripts": { "secrets": "OP_ACCOUNT=putdotio.1password.com op inject -f -i .env.example -o .env.local" } }
```

```just
# justfile
secrets:
    OP_ACCOUNT=putdotio.1password.com op inject -f -i .env.example -o .env.local
```

### `.gitignore`

```
.env
.env.*
!.env.example
!.env.example
.direnv/
```

The `!.env.example` exception is **required** — without it, a blanket `.env.*` rule silently un-tracks the template and the next `git add` skips it. Verify with `git check-ignore -v .env.example` (it must report no match).

## Targets That Need Secrets

Default verify (`build`, `test`, `lint`, `typecheck`) must work without secrets. Targets that genuinely need them either declare `secrets` as a task dependency, or wrap the command in `op run` for one-shots that should not persist secrets to disk:

```makefile
live-test: secrets
	pnpm test:live
```

```bash
OP_ACCOUNT=putdotio.1password.com op run --env-file=.env.example -- pnpm test:live
```

Do not auto-bootstrap from build/test/lint/typecheck, in CI or in agent flows. Do not wire `secrets` into `prepare`, `postinstall`, or `prebuild` lifecycle hooks — those run on `pnpm install` and would force every contributor (including those without 1Password) through the bootstrap.

## Verify

```bash
# .envrc is the one-liner and parses
test "$(cat .envrc)" = "dotenv_if_exists .env.local"
bash -n .envrc

# .env.local gitignored, .env.example tracked
git check-ignore -v .env.local
git check-ignore -v .env.example && echo "WRONG: .env.example must be tracked" || true

# direnv loads cleanly with no .env.local
direnv allow && direnv exec . sh -c 'echo direnv ok'

# bootstrap pre-flight
op whoami --account=putdotio.1password.com

# bootstrap produces a 0600 file with no unresolved op:// refs
<repo's secrets target>
test -f .env.local
# portable mode check (BSD: stat -f, GNU: stat -c)
mode=$(stat -f '%Mp%Lp' .env.local 2>/dev/null || stat -c '%a' .env.local)
test "$mode" = "600" && echo mode ok || echo "WRONG: mode=$mode"
grep -q 'op://' .env.local && echo "WRONG: unresolved op:// in .env.local" || echo refs ok
```

## Public Repo Notes

- Build, test, lint, typecheck must pass without `.env.local`. If any depend on secrets, move the secret-dependent flow to a separate target (`live-test`, `deploy`, `release`) that documents its requirement
- `secrets` is a committer-only target in public repos; routine contributors ignore it
- If an item title would reveal something better kept internal, rename it in 1Password rather than obscuring the `op://` reference

## Devbox And CI

Same `secrets` target works on shared devboxes and in CI when `OP_SERVICE_ACCOUNT_TOKEN` is exported. The `OP_ACCOUNT` pin is harmless once the SA token is set — `op` resolves through the token. Verify non-interactive SSH sessions actually inherit the token on the box before declaring the devbox path live.
