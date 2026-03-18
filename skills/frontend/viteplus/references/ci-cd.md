# CI/CD

Use this reference before changing GitHub Actions or release flows.

## CI Baseline

Prefer the documented VitePlus setup:

```yaml
- uses: voidzero-dev/setup-vp@v1
  with:
    node-version-file: ".node-version"
    cache: true
```

Then prefer:

```yaml
- run: vp install
- run: vp check
- run: vp test
- run: vp pack
```

## Migration Heuristics

- Replace `setup-node + corepack + pnpm install` with `setup-vp` unless the repo has a proven exception.
- Prefer `vp run <script>` when CI needs a repo-specific script that VitePlus does not replace.
- Keep release orchestration in GitHub Actions when the repo has npm, GitHub Release, binary, or Homebrew automation that goes beyond stock VitePlus.

## Guardrails

- Do not rewrite a release pipeline just to make it look more "standard."
- Change one axis at a time when the repo has active release automation:
  - CI bootstrap first
  - then package scripts
  - then test surface
- After workflow edits, validate YAML and run the repo guardrail locally before pushing.
