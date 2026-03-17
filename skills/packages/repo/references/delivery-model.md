# Package Repo Delivery Model

Use this as the default package-repo shape at put.io. The current reference example is the new `putio-sdk-typescript` repo layout.

## Core Model

- `VERIFY` runs on pull requests and `main` pushes.
- `RELEASE` runs on `main` only, after `VERIFY` passes.
- The repo exposes one local `verify` entrypoint that CI calls directly.
- Releases are continuous: every merge to `main` is assumed releasable.

## Default Shape

1. One repo-local verify command or script.
2. One `verify` CI job that runs it.
3. One `release` job gated on `verify`.
4. Conventional commits or another deterministic release signal.
5. No manual version bump flow in normal delivery.

## Checklist

- `VERIFY` covers lint, typecheck, build, tests, and any package-specific guardrails.
- Workflow logic stays thin; repo commands own the complexity.
- `RELEASE` is safe to no-op when there are no releasable commits.
- Release jobs use only the permissions and secrets they actually need.
- Release automation fetches full git history when versioning depends on commits or tags.
- For Swift, Kotlin, and other ecosystems, keep this model and choose the smallest repo-native toolchain that CI can call unchanged.
