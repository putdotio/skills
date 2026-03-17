# Frontend README Guideline

Use this when shaping a put.io frontend README. Copy the structure, not the wording.

## Observed put.io Pattern

The current `putio-sdk-typescript` README is a good reference point:

- compact brand-forward hero
- optional boncuk or brand image
- sparse trust badges
- installation near the top
- one short example per supported entry path
- comparison table only when readers need help choosing
- deeper technical detail pushed downward or linked out to `docs/*`

## Default Shape

Use this order unless the repo gives a strong reason not to:

1. Hero
2. Installation or local setup
3. Quick usage or first successful flow
4. Optional comparison or integration table
5. Project structure or architecture overview
6. Operational notes developers actually need
7. Links to deeper docs

If the repo is mostly a package, prefer `Installation` then `Usage`.

If the repo is mostly an app, prefer `Local Setup` then `Run` or `Development`.

## Hero And Badges

- Use a brand block only when the repo has a real recognizable asset.
- Keep the hero compact: name, one-sentence purpose, optional positioning sentence.
- Good badges: CI status, version, downloads when relevant, license.
- Skip decorative badges that do not help trust, adoption, or navigation.

## Usage And Links

- Put the fastest successful path near the top.
- For package repos, show install commands in a compact block or matrix.
- For app repos, show install, required env setup, and the command that starts the app.
- If multiple entry paths exist, show one short example per path and add a compact “how to choose” note or table.
- Put “how do I run this” above “how is this built”.
- Keep snippets copy-pastable.
- Move long testing, architecture, and runbook detail to `docs/*`.

## Checklist

- The first screen answers what this repo is and how to start.
- Installation or local setup is easy to scan.
- Usage appears before deep technical background.
- Variants are compared only when multiple entry paths truly exist.
- The README links out before it turns into a handbook.
- Every command, doc path, and badge target is verified against the repo.
