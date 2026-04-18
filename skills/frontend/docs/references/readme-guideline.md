# Frontend Repo Docs Guideline

Use this when shaping top-level docs for a put.io frontend repo. Copy the structure, not the wording.

## Core Split

- `README.md` is user-facing.
- `CONTRIBUTING.md` is developer-facing.
- `LICENSE` states the license.
- `SECURITY.md` explains private-first vulnerability disclosure and points reporters to `ui@put.io`.

This separation keeps “how do I use this?” out of contributor docs and keeps “how do I set up my environment?” out of the README.

## README.md

Use this order unless the repo gives a strong reason not to:

1. Hero
2. Install
3. Quick usage or first successful flow
4. Optional examples, variants, or integration notes
5. Docs
6. Contributing
7. License

- Answer these questions on the first screen: what is this project, how do I install it, and how do I use it.
- For package repos, show install commands and one short usage example.
- For app repos, show the user-facing way to access or use the app; contributor setup belongs in `CONTRIBUTING.md`.
- Add a compact `Docs` section. When deeper docs exist, use it to link to them; otherwise use it for lightweight project navigation.
- Add a short `Contributing` section that points to `CONTRIBUTING.md`.
- Add a short `License` section that points to `LICENSE`.
- Link to `SECURITY.md` from the README when it materially helps navigation, but do not let it crowd the main user flow.
- Link to deeper docs before the README turns into a handbook.

## Hero And Badges

- Use a brand block only when the repo has a real recognizable asset.
- Keep the hero compact: name, one-sentence purpose, optional positioning sentence.
- Good badges: CI status, version, downloads when relevant, license.
- Skip decorative badges that do not help trust, adoption, or navigation.
- For put.io repos that use shields badges, follow the `putio-sdk-typescript` pattern: `style=flat`, `colorA=000000`, `colorB=000000`, and `style="text-decoration:none;"` on each badge link.
- Keep badge styling consistent within the hero block. Do not mix black shields with default-colored or glossy variants.

## Docs Section

- Use this section to link to deeper docs without dumping their contents into the README.
- Keep the section even when the repo only has a small set of links.
- Common links include About, Guides, Architecture, Deployment, and Security when those docs exist.
- Avoid repeating the same doc-link lists in multiple top-level files. Keep one canonical navigation area and let other docs link to it sparingly.
- Keep it skimmable: a short list is usually enough.

## CONTRIBUTING.md

Use this order unless the repo gives a strong reason not to:

1. Setup
2. Run locally
3. Validation
4. Development notes
5. Pull request expectations
6. Release notes only if contributors genuinely need them

- Put environment bootstrap first.
- Include only contributor-facing commands here: install toolchain, install dependencies, run locally, run checks.
- Start from `references/contributing-template.md` when the repo needs a new contributor guide.
- Keep commands copy-pastable and verified against the repo.
- Document repo-specific development constraints only when they materially help contributors.

## SECURITY.md

- Keep it short and private-first.
- Tell reporters not to file public issues for vulnerabilities.
- Use `ui@put.io` as the contact email.
- Start from `references/security-template.md` when the repo needs a new security policy.
- Link to the security policy from `README.md` when helpful.

## LICENSE

- Ensure the repo has one.
- Reference it from `README.md`.

## Checklist

- `README.md` answers what the project is, how to install it, and how to use it.
- `README.md` includes a compact `Docs` section.
- `README.md` includes short `Contributing` and `License` sections that point to the canonical files.
- `CONTRIBUTING.md` explains how to set up an environment to contribute and how to validate changes.
- `SECURITY.md` uses private-first disclosure and points to `ui@put.io`.
- `LICENSE` exists and is linked where appropriate.
- User-facing docs do not drift into contributor setup.
- Contributor docs do not re-explain end-user usage unless it helps local development.
- Repeated doc references live in one canonical place instead of being copied across multiple files.
- Every command, doc path, badge target, and contact address is verified against the repo.
