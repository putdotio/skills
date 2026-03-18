# Testing

Use this reference when migrating tests to VitePlus-native usage.

## Target Shape

- imports from `vite-plus/test`
- test execution through `vp test`
- coverage through `vp test --coverage`

## Migration Pattern

1. Replace imports from `vitest` with `vite-plus/test`.
2. Replace direct `vitest run` scripts with `vp test`.
3. Re-run the full suite before touching coverage.
4. If coverage is enabled through `provider: "v8"`, verify whether `@vitest/coverage-v8` is still required.

## Known Caveat

At the time this skill was written, adding `@vitest/coverage-v8` to a VitePlus project can still produce a mixed-version warning during `vp test --coverage`, even in a fresh stock scaffold. Treat that as a VitePlus limitation to verify and document, not as an automatic repo regression.

## Verification

- run the repo's top-level verify command
- run `vp test`
- run `vp test --coverage` if the repo claims coverage support
- compare behavior against a fresh `vp create vite:library` scaffold when unsure whether an issue is repo-specific
