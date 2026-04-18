# Repo Delivery Model

Use this as the default frontend repo shape at put.io. Package repos publish continuously. App repos deploy continuously.

## Core Model

- `VERIFY` runs on pull requests and `main` pushes.
- delivery runs on `main` only, after `VERIFY` passes.
- GitHub Actions owns orchestration; the repo owns build, test, and publish-ready or deploy-ready commands.
- The repo exposes one local `verify` entrypoint that CI calls directly.
- Delivery is continuous: every merge to `main` is assumed publishable or deployable.

## Default Shape

1. One repo-local verify command or script.
2. One `verify` CI job that runs it.
3. One delivery job gated on `verify`.
4. Conventional commits or another deterministic release or deploy signal.
5. No manual version bump or deploy checklist flow in normal delivery.
6. No repo-local release-only tooling by default; prefer workflow-level execution.

## Checklist

- `VERIFY` covers lint, typecheck, build, tests, and any package-specific guardrails.
- Workflow logic stays thin; repo commands own the complexity.
- Orchestration stays in GitHub Actions unless there is an established repo standard that says otherwise.
- Package release jobs are safe to no-op when there are no releasable commits.
- Delivery jobs use only the permissions and secrets they actually need.
- Release automation fetches full git history when versioning depends on commits or tags.
- For Swift, Kotlin, and other ecosystems, keep this model and choose the smallest repo-native toolchain that CI can call unchanged.
- Packages publish. Apps deploy. The verify-first model stays the same.
