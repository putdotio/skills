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

Install a specific skill from this repo:

```bash
npx skills add https://github.com/putdotio/skills --skill putio-frontend-docs
```

```bash
npx skills add https://github.com/putdotio/skills --skill putio-package-repo
```

## Current Skills

| Skill | Use it for |
| --- | --- |
| `putio-frontend-docs` | Structure frontend repo docs, especially top-level README files |
| `putio-package-repo` | Standardize package repos around `verify` and automatic release on `main` |

## Repo Shape

```text
skills/
  frontend/
    docs/
  packages/
    repo/
```

`packages/repo` uses the new `putio-sdk-typescript` layout as its current reference.
