# TypeScript Package Defaults

Use the new `putio-sdk-typescript` layout as the default TypeScript package reference.

## Defaults

- Use Vite+ (`vp`) for install, check, build, and test flows.
- Expose one repo-local `verify` script and let CI call it directly.
- Prefer the same package-repo shape across TypeScript libraries so setup and maintenance stay boring.
- Prefer GitHub Actions for release orchestration.
- If the repo uses semantic-release for npm publishing and release notes, run it from the release workflow instead of installing release-only tooling into the package by default.

## Expected Shape

- local commands for `check`, `build`, `test`, and `verify`
- CI setup with `voidzero-dev/setup-vp`
- `vp install` before verification or release
- `verify` on pull requests and `main` pushes
- a GitHub Actions release job on `main` after `verify` passes

## Build Tooling

- Use the current team default toolchain for package builds, including Vite+ and `tsdown` where appropriate.
- Keep build-tool choice behind repo scripts so the workflow model does not change when packaging details do.
- If a repo needs a different build tool, preserve the same verify/release shape unless there is a strong reason not to.
