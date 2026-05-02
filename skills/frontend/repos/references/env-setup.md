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

Body is identical across runners — `OP_ACCOUNT` is pinned **inside** the target so the recipe is hermetic regardless of the engineer's shell env, and the `op inject` line cannot resolve against an engineer's personal 1Password account by accident:

```bash
OP_ACCOUNT=<account>.1password.com op whoami >/dev/null
OP_ACCOUNT=<account>.1password.com op inject -f -i .env.example -o .env.local
```

The `op whoami` pre-flight fails fast with a clear message if 1Password is locked or unavailable. `op inject -f` overwrites without prompting. Output mode is 0600 by default; no separate `chmod` needed. Same recipe runs locally (personal `op`), on devbox (`OP_SERVICE_ACCOUNT_TOKEN` exported), and in CI.

Bindings:

```makefile
# Makefile
.PHONY: secrets secrets-clean
secrets:
	OP_ACCOUNT=<account>.1password.com op whoami >/dev/null
	OP_ACCOUNT=<account>.1password.com op inject -f -i .env.example -o .env.local
secrets-clean:
	rm -f .env.local
```

```json
// package.json
{ "scripts": {
  "secrets": "OP_ACCOUNT=<account>.1password.com op whoami >/dev/null && OP_ACCOUNT=<account>.1password.com op inject -f -i .env.example -o .env.local",
  "secrets-clean": "rm -f .env.local"
} }
```

```just
# justfile
secrets:
    OP_ACCOUNT=<account>.1password.com op whoami >/dev/null
    OP_ACCOUNT=<account>.1password.com op inject -f -i .env.example -o .env.local
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

The non-negotiable shape — protects against PR-driven secret exfiltration and supply-chain attacks. Each rule below is mandatory for repos that adopt this contract.

### Trigger discipline

- **PR verify on `pull_request`** — the workflow MUST NOT map `OP_SERVICE_ACCOUNT_TOKEN` (or any sensitive secret) into any job. `pull_request` from internal branches DOES receive `secrets.*` if the workflow references them; the protection is "the workflow author never wires it in." Fork PRs additionally have no access to repo secrets at all
- **Deploy / release / live-test on `push: main` or `workflow_dispatch`** — these workflows reference Environment-scoped secrets, gated by required reviewers. `workflow_dispatch` is only allowed when the Environment's deployment-branch policy restricts the runnable ref to `main` or protected release branches; otherwise an internal-branch dispatcher can run PR-context code with secrets after one approval
- **Never `pull_request_target` for code-running steps** — including `actions/checkout` against PR head, label automation that uses checkout, or composite actions that run PR-supplied scripts
- **Never `workflow_run` triggered by a `pull_request` workflow that reads PR-supplied data** — classic exfiltration vector
- **Reusable workflows (`uses: org/repo/.github/workflows/x.yml@ref`)** hide the trigger event in review; pin to SHA and CODEOWNER-gate them

### Where secrets live

- The 1Password service-account token lives ONLY in a GitHub Deployment Environment (e.g., `production`, `release`)
- **NEVER** as a repo Actions secret — those are accessible to any workflow including `pull_request`
- Environment must have **required reviewers** set, with **"Prevent self-review"** enabled

### Workflow defaults

- Top-level `permissions: {}` (deny by default); each job opts into the minimum it needs
- Pin all third-party actions to SHA, not tag
- For 1Password-backed secret loading, use `1Password/load-secrets-action@<sha>` reading `OP_ENV_FILE=.env.example`

### Repo configuration

Load-bearing (mandatory):

- Deployment Environment with required reviewers and Prevent self-review on every workflow that maps a sensitive secret. The only mechanical gate between a compromised committer and a deploy
- Dependabot configured for the `github-actions` ecosystem so pinned workflow SHAs get bumped as reviewable PRs

Additional hygiene (adopt where team size supports a real PR review process):

- Branch protection on `main`: required PR review, no force-push, no admin bypass
- CODEOWNERS on `.github/workflows/**`, `.github/actions/**`, `.env.example`, the `secrets`/`secrets-clean` target body, and lockfiles. Without branch protection, CODEOWNERS is advisory only
- Signed commits

### Cache scoping

Cache keys must scope per-event so PR (no-secrets) jobs cannot poison caches consumed by `push: main` (with-secrets) jobs. Include `${{ github.event_name }}` in `actions/cache` keys.

## Agent Contexts

How agents (Claude Code, Codex, etc.) get credentials when working in a worktree. The same `op` calls and the same `secrets` target work in all three contexts — agents do not branch on context.

| Context | Credential source | Setup |
|---|---|---|
| **Local laptop** (agent on engineer's machine) | Inherits the shell env + the engineer's unlocked 1Password CLI session via desktop integration | 1P desktop integration on, biometric unlock enabled, auto-lock set to engineer preference (avoid "Never until I quit"), app unlocked at session start. No `OP_SERVICE_ACCOUNT_TOKEN` in personal shells |
| **Shared devbox** (SSH or remote agent on a shared VM) | `OP_SERVICE_ACCOUNT_TOKEN` exported into the shared user's non-interactive shell. Practical path: store the token in `/etc/<org>/op.env` (mode `0600`, owned by the shared user) and source it from `/etc/profile.d/<org>-op.sh` or the user's `~/.zshenv` so SSH sessions inherit it. systemd `EnvironmentFile=` only reaches the unit that declares it; `/etc/environment` is world-readable | Operator pre-installs. Verify with `ssh user@host 'env | grep OP_SERVICE_ACCOUNT_TOKEN'` |
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

### Untrusted code

The line is **"anything you did not author personally"**, not "anything from a fork." Compromised internal accounts and malicious dependencies are real attack vectors. Mitigations per context:

- **Local laptop**: personal `op` session is unlocked; a malicious script could call `op read`. Mitigation = vault-scope discipline + per-item authentication on sensitive items + auto-lock to bound the window
- **Devbox / Cloud**: SA token is in env; a malicious script could exfiltrate it. **Do not run untrusted code (including internal-PR code from someone you don't personally trust) on these contexts** — use a separate sandbox for review
