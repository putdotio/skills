# Env Setup

Use this reference when a put.io frontend-owned repo has 1Password-backed local, live-test, build, signing, or deploy workflows. Defines the repo-side mechanics — detect, scaffold, verify — and is self-contained: external contributors and future agents can apply it without access to internal operator docs.

**Out of scope**: repos with native non-task-runner build systems (e.g. Xcode + Fastlane), repos that *hold* signing material consumed by tools like `match`, and repos whose `.env`/`.env.example` carry plain device or runtime credentials rather than 1Password references. Those follow their repo-local setup.

## Detect

```bash
rg -n 'op (run|inject|read|item|whoami|signin)|OP_SERVICE_ACCOUNT_TOKEN|op://|load-secrets-action' \
  AGENTS.md README.md CONTRIBUTING.md SECURITY.md docs .github Makefile package.json build.gradle.kts Package.swift .env.example scripts tooling apps Tests src 2>/dev/null

test -f .env.example && cat .env.example
test -f .envrc && cat .envrc
```

Repos with no real 1Password hits and no `.env.example` need none of the below — leave them alone.

If `.envrc` already exists with content beyond the one-liner (a multi-line `dotenv_if_regular_file_or_fifo_exists` block, or `use mise`/runtime pins/PATH manipulation), confirm with the operator before overwriting — those carry meaning. If `.env.example` already exists with bare-key placeholders for non-1Password values (e.g. local device creds), preserve those entries when migrating to `op://` references; do not silently replace mixed content.

## Standard Shape

A secrets-using repo carries five artefacts.

### Tracked `.envrc` (one line)

```bash
dotenv_if_exists .env.local
```

Identical across public and private repos. Travels with `git worktree add`. Approved per worktree with `direnv allow`. Loads nothing if `.env.local` is missing — safe in public repos.

### Tracked `.env.example` (literal `op://` references)

```
PUTIO_API_KEY=op://<vault>/<item>/<field>
PUTIO_TEST_USER=op://<vault>/<item>/<field>
```

Vault and item names go literally into the file. They are operational metadata, not secrets — the access control is the 1Password vault itself, not the names. The same template works for both `op inject` and `op run --env-file`.

### `secrets` target in the repo's native task runner

Body is identical across runners:

```bash
op whoami --account=<account>.1password.com >/dev/null
op inject -f -i .env.example -o .env.local
```

The `op whoami` pre-flight fails fast with a clear message if 1Password is locked or unavailable. `op inject -f` overwrites without prompting. Output mode is 0600 by default; no separate `chmod` needed. Same recipe runs locally (personal `op`), on devbox (`OP_SERVICE_ACCOUNT_TOKEN` exported), and in CI.

Bindings:

```makefile
# Makefile
.PHONY: secrets secrets-clean
secrets:
	op whoami --account=<account>.1password.com >/dev/null
	op inject -f -i .env.example -o .env.local
secrets-clean:
	rm -f .env.local
```

```json
// package.json
{ "scripts": {
  "secrets": "op whoami --account=<account>.1password.com >/dev/null && op inject -f -i .env.example -o .env.local",
  "secrets-clean": "rm -f .env.local"
} }
```

```just
# justfile
secrets:
    op whoami --account=<account>.1password.com >/dev/null
    op inject -f -i .env.example -o .env.local
secrets-clean:
    rm -f .env.local
```

### `secrets-clean` target

Run before `git worktree remove` so stale resolved secrets don't sit on disk.

### `.gitignore`

```
.env
.env.*
!.env.example
.direnv/
```

The `!.env.example` exception is **required** — without it, the blanket `.env.*` rule silently un-tracks the template. Verify with `git check-ignore -v .env.example` (it must report no match).

## Targets That Need Secrets

Default verify (`build`, `test`, `lint`, `typecheck`) must work without secrets. Targets that genuinely need them either declare `secrets` as a task dependency, or wrap the command in `op run` for one-shots that should not persist secrets to disk:

```makefile
live-test: secrets
	pnpm test:live
```

```bash
op run --env-file=.env.example -- pnpm test:live
```

Do not auto-bootstrap from build/test/lint/typecheck, in CI or in agent flows. Do not wire `secrets` into `prepare`, `postinstall`, or `prebuild` lifecycle hooks — those run on `pnpm install` and would force every contributor (including those without 1Password) through the bootstrap.

## Verify

```bash
test "$(cat .envrc)" = "dotenv_if_exists .env.local"
bash -n .envrc

git check-ignore -v .env.local
git check-ignore -v .env.example && echo "WRONG: .env.example must be tracked" || true

direnv allow && direnv exec . sh -c 'echo direnv ok'

op whoami --account=<account>.1password.com >/dev/null

<repo's secrets target>
test -f .env.local
mode=$(stat -f '%Mp%Lp' .env.local 2>/dev/null || stat -c '%a' .env.local)
test "$mode" = "600" && echo mode ok || echo "WRONG: mode=$mode"
grep -q 'op://' .env.local && echo "WRONG: unresolved op:// in .env.local" || echo refs ok

<repo's secrets-clean target>
test ! -f .env.local && echo cleanup ok
```

## Public Repo Notes

- Build, test, lint, typecheck must pass without `.env.local`. If any depend on secrets, move the secret-dependent flow to a separate target (`live-test`, `deploy`, `release`) that documents its requirement
- `secrets` is a committer-only target in public repos; routine contributors ignore it
- If an item title would reveal something better kept internal, rename it in 1Password rather than obscuring the `op://` reference

## CI/CD

The non-negotiable shape — protects against PR-driven secret exfiltration:

- **PR verify on `pull_request`**, no `OP_SERVICE_ACCOUNT_TOKEN`. Forks run with no access to repo secrets, so PR code can't exfiltrate what isn't there
- **Deploy / release / live-test on `push: main` or `workflow_dispatch`**, targeting a GitHub Environment with required reviewers. The job cannot read its environment secrets until a maintainer approves
- **Never `pull_request_target` for code-running steps** — PR code with access to repo secrets is the standard exfiltration vector
- **Pin third-party actions to SHA**, not tag

For 1Password-backed secrets in CI, use `1password/load-secrets-action@<sha>` with `OP_ENV_FILE=.env.example` exporting resolved values for subsequent steps. Same `.env.example` as local; no separate CI template.

## Agent Contexts

How agents (Claude Code, Codex, etc.) get credentials when working in a worktree. The same `op` calls and the same `secrets` target work in all three contexts — agents do not branch on context.

| Context | Credential source | Setup |
|---|---|---|
| **Local laptop** (agent on engineer's machine) | Inherits the shell env + the engineer's unlocked 1Password CLI session via desktop integration | 1P desktop integration on, biometric unlock enabled, auto-lock set generously, app unlocked at session start. No `OP_SERVICE_ACCOUNT_TOKEN` in personal shells |
| **Shared devbox** (SSH or remote agent on a shared VM) | `OP_SERVICE_ACCOUNT_TOKEN` set at the machine level — systemd unit, `/etc/environment`, or operator-installed shell init | Operator pre-installs the token. Verify non-interactive SSH sessions actually inherit it (`/etc/environment` is read by PAM only; systemd unit env doesn't flow to user shells) |
| **Cloud agent** (Codex Cloud, Claude Code Cloud, etc.) | `OP_SERVICE_ACCOUNT_TOKEN` configured as a workspace secret in the agent platform | One-time setup per workspace; the VM inherits the token |

### Per-worktree onboarding

```bash
git worktree add ../<repo>.<topic> <branch>
cd ../<repo>.<topic>
direnv allow                    # one-time per worktree
<runner> secrets                # only when this worktree needs .env.local
<runner> secrets-clean          # before `git worktree remove`
```

Tracked `.envrc` and `.env.example` travel with the worktree. `.env.local` is materialised per-worktree, never shared.

### Harness ergonomics

- Configure agent harnesses to auto-approve `direnv allow` on trusted repo paths so worktree onboarding doesn't need manual click-through
- Have 1Password launch on login with biometric unlock so the CLI session is alive at session start
- For unattended runs, use a devbox or Cloud agent context where the SA token is always present, not a personal laptop where the desktop session may auto-lock

### Untrusted PR code

Agents that review or run code from forks can be poisoned by malicious `postinstall` hooks or test code that reads env. Mitigations:

- **Local laptop**: personal `op` session is unlocked; a malicious script could call `op read`. Mitigation = vault-scope discipline + per-item authentication on sensitive items
- **Devbox / Cloud**: SA token is in env; a malicious script could exfiltrate it. **Do not run untrusted PR code on these contexts** — use a separate sandbox (different VM, no SA token) for reviewing fork PRs
