<div align="center">
  <p>
    <img src="https://static.put.io/images/putio-boncuk.png" width="72" alt="put.io logo">
  </p>

  <h1>putdotio/skills</h1>

  <p>Shared agent skills for put.io development workflows.</p>
</div>

## Installation

```bash
npx skills add putdotio/skills
```

Install one skill directly:

```bash
npx skills add https://github.com/putdotio/skills --skill putio-frontend-docs
```

## Quick Usage

Install the collection, then use the skill that matches the job:

- `putio-frontend-docs` for concise frontend repo docs with a clean README and contributor-doc split
- `putio-frontend-packages` for package repos centered around `verify` and releasable `main`
- `putio-frontend-viteplus` for moving frontend repos toward the stock VitePlus workflow

## Docs

- [`skills/frontend/docs/SKILL.md`](skills/frontend/docs/SKILL.md)
- [`skills/frontend/packages/SKILL.md`](skills/frontend/packages/SKILL.md)
- [`skills/frontend/viteplus/SKILL.md`](skills/frontend/viteplus/SKILL.md)

## Validate

```bash
./skills/frontend/docs/scripts/check-doc-links.sh
```
