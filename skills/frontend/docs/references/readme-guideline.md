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
5. Links to deeper docs
6. Contributing, security, and license links

- Answer these questions on the first screen: what is this project, how do I install it, and how do I use it.
- For package repos, show install commands and one short usage example.
- For app repos, show the user-facing way to access or use the app; contributor setup belongs in `CONTRIBUTING.md`.
- Link to deeper docs before the README turns into a handbook.

## Hero And Badges

- Use a brand block only when the repo has a real recognizable asset.
- Keep the hero compact: name, one-sentence purpose, optional positioning sentence.
- Good badges: CI status, version, downloads when relevant, license.
- Skip decorative badges that do not help trust, adoption, or navigation.

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
- Keep commands copy-pastable and verified against the repo.
- Document repo-specific development constraints only when they materially help contributors.

## SECURITY.md

- Keep it short and private-first.
- Tell reporters not to file public issues for vulnerabilities.
- Use `ui@put.io` as the contact email.
- Link to the security policy from `README.md` when helpful.

## LICENSE

- Ensure the repo has one.
- Reference it from `README.md`.

## Checklist

- `README.md` answers what the project is, how to install it, and how to use it.
- `CONTRIBUTING.md` explains how to set up an environment to contribute and how to validate changes.
- `SECURITY.md` uses private-first disclosure and points to `ui@put.io`.
- `LICENSE` exists and is linked where appropriate.
- User-facing docs do not drift into contributor setup.
- Contributor docs do not re-explain end-user usage unless it helps local development.
- Every command, doc path, badge target, and contact address is verified against the repo.
