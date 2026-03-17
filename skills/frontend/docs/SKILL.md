---
name: putio-frontend-docs
description: Structure and rewrite docs for frontend repositories, especially top-level README files. Use when creating a new frontend README, reorganizing existing frontend docs, improving section order, or reducing README sprawl.
---

# Frontend Docs

Shape frontend repo docs around a concise top-level README that helps a new developer understand what the repo is, how to run it, and where to go next.

## Workflow

1. Inspect the repository before drafting.
2. Identify the app type, main stack, local run flow, and any existing docs worth linking.
3. Read [references/readme-guideline.md](references/readme-guideline.md) before picking a final shape.
4. Keep only the information that belongs in a top-level README.
5. Push deep implementation detail into linked docs when it starts to bloat the page.
6. Verify that every claimed command, path, and doc link exists.

## Guardrails

- Do not guess commands, environment variables, or deployment behavior.
- Do not duplicate long content that already lives in repo docs.
- Keep the README focused on onboarding and navigation; link out before it becomes a handbook.
- Do not hardcode volatile metrics such as test counts or coverage numbers.
- Do not add generic filler sections that say nothing specific about the repo.
