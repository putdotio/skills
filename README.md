<div align="center">
  <p>
    <img src="https://static.put.io/images/putio-boncuk.png" width="72">
  </p>

  <h1>putdotio/skills</h1>

  <p>
    Shared agent skills for put.io development workflows.
  </p>
</div>

## Installation

Install the collection with the `skills` CLI:

```bash
npx skills add putdotio/skills
```

Or install one skill directly:

```bash
npx skills add https://github.com/putdotio/skills --skill putio-frontend-docs
```

## Current Skills

| Skill | Use it for |
| --- | --- |
| `putio-frontend-docs` | Structure frontend repo docs with a clear split between user-facing README.md and contributor-facing CONTRIBUTING.md |
| `putio-frontend-packages` | Standardize future package repos around `verify` and automatic release on `main` |
