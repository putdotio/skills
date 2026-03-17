# put.io Skills

Shared agent skill library for put.io developers.

This repo is a home for reusable agent skills that encode team workflows, repo conventions, and domain knowledge. The goal is to keep skills small, practical, and easy to iterate on as we learn what is actually useful in day-to-day work.

## Structure

```text
skills/
  frontend/
    docs/
      SKILL.md
      agents/openai.yaml
```

Use top-level folders in `skills/` as simple namespaces such as `frontend`, `backend`, or `ops`.

## Conventions

- Keep each skill in its own folder named with lowercase hyphen-case.
- Keep `SKILL.md` focused on workflow and decision-making.
- Add `references/`, `scripts/`, or `assets/` only when the skill genuinely needs them.
- Keep durable repo guidance in the repo instead of chat threads.

## Current Skills

- `frontend/docs` (`putio-frontend-docs`): structure frontend repository docs, starting with top-level README shape and organization.

## Next Steps

- Add more shared skills under `skills/`.
- Iterate on skill content after real usage.
- Expand the frontend namespace with additional repo, UI, and release workflows over time.
