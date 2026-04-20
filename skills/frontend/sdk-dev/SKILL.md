---
name: putio-sdk-dev
description: Develop or review put.io SDK repositories, API clients, and client libraries across TypeScript, Swift, Kotlin, and similar packages. Use when adding or changing namespaces, tightening request or error types, aligning SDK behavior with backend and app usage, updating SDK verification flows, or checking how an SDK repo should be documented and released.
---

# put.io SDK Dev

Use this skill when working in a put.io SDK repository rather than an end-user app.

## Quick Rules

- Treat each SDK as a public package, not an internal compatibility layer.
- Keep the public surface domain-first and strongly typed for the host language.
- Parse external data at the boundary and preserve typed errors as first-class contracts.
- For TypeScript SDKs, default to the strictest safe contract shape the package can support.
- Treat both deterministic unit tests and safe live tests as part of a healthy SDK repo.
- Prefer the repo's native architecture and verification style instead of forcing one SDK's implementation style onto another.

## Source Of Truth Order

When docs, runtime behavior, and consumers disagree, trust sources in this order:

1. the local backend clone and its tests
2. current first-party app usage such as web, iOS, Android, or TV clients
3. the closest actively maintained put.io SDKs in this workspace
4. archived SDKs or historical open-source clients
5. published Swagger and public API docs

Do not widen an SDK surface just because another SDK already has it. Match real app use and verified backend behavior.

## Start Here

Read only what you need:

- the repo-local `AGENTS.md`
- package overview such as `README.md`
- architecture and testing docs under `docs/*`
- release docs when the change affects publishing or CI
- [references/patterns.md](references/patterns.md) when you need concrete examples for typed boundaries, live-test layering, or multi-client alignment

If the repo has a canonical verify command, use that as the source of truth before editing delivery automation.

## Main Workflow

1. Inspect the target namespace and the shared transport or client runtime.
2. Check backend behavior, backend tests, and current app usage before changing a contract.
3. Update request, response, and error models together.
4. Run the repo's canonical verify command after contract changes and fix failures before continuing.
5. Add or update deterministic unit coverage for request shaping, parsing, errors, and client contracts changed by the work.
6. Add or update live verification when the surface is safe to exercise against shared accounts, especially for real API behavior that unit tests cannot prove alone.
7. Keep multiple public clients aligned when the repo exposes more than one interface style.
8. Update package-facing docs and release notes when the public surface changes.

Concrete checks:

```bash
rg -n "<namespace|endpoint|field>" src test docs
rg -n "<namespace|endpoint|field>" ../backend ../apps ../sdks
rg -n "verify|liveTest|test:live|example" README.md AGENTS.md docs .github
```

## Type And Contract Rules

- prefer explicit enums, discriminated unions, sealed hierarchies, or value wrappers over optional bags
- prefer parameter-aware return types and conditional typing where the SDK already models contract differences that way
- preserve unknown backend enum or string values when forward compatibility matters
- update request, response, and error contracts together so the typed surface cannot silently drift
- keep transport helpers in shared core files and domain logic in namespace or feature modules
- avoid compatibility aliases and legacy naming unless the SDK already exposes them as supported API
- follow the concrete patterns in [references/patterns.md](references/patterns.md) when the repo does not already establish a better local convention

Short examples:

```ts
const FileSchema = Schema.Struct({ id: Schema.Number, name: Schema.String });
type PutioFile = Schema.Schema.Type<typeof FileSchema>;
```

```kotlin
@JvmInline
value class PutioFileType(val raw: String)
```

## Repo-Specific Notes

Choose the guidance that matches the SDK you are in:

- TypeScript: stay Effect-first, keep `Schema` at boundaries for request, response, config, and error shapes, keep Promise and Effect clients aligned, prefer discriminated unions and explicit exports over loose option bags, and do not weaken the surface with unsafe casts or ignored type failures unless explicitly approved
- Kotlin: prefer coroutine-first APIs, keep models serialization-friendly, and stay close to the TypeScript contract shape
- Swift: keep the package surface open-source-safe, preserve the package and CocoaPods install surface, and verify the example app when auth or integration behavior changes

## Verification

Run the checks that match the repo instead of inventing ad hoc commands.
Healthy SDK repos in this workspace should expose both:

- a default deterministic unit-test path that is safe for CI and local iteration
- a separate documented live-test path for real API verification

If one of those layers is missing, treat it as a repo gap to document or fix rather than silently accepting a weaker verification story.

Minimal shape:

```bash
vp run verify && vp run test:live
./gradlew verify && ./gradlew liveTest
```

Common examples in this workspace:

```bash
vp run verify
./gradlew verify
make verify
```

For runtime verification, prefer the repo's documented live-test entrypoints and follow the shared-account safety rules in that repo's testing docs.

## Guardrails

- Do not guess backend contracts from old SDKs alone.
- Do not claim an SDK change is fully verified if only unit tests or only live probes were exercised when both layers matter.
- Do not add live destructive coverage against shared accounts.
- Do not let one SDK drift into naming or behavior that breaks parity without a documented reason.
- Do not trade away type-safety in TypeScript packages for convenience when the repo already has a stronger typed pattern.
- Do not copy repo-specific implementation guidance into this shared skill when it belongs in that repo's `AGENTS.md` or `docs/*`.
