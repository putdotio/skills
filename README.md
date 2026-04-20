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

## Tessl

Use [Tessl](https://tessl.io/) to review and publish the skills in this repo to the `putio` workspace.

```bash
./scripts/review-skills.sh
./scripts/optimize-skills.sh frontend/docs
```

Per-skill checks:

```bash
npx tessl skill review --json skills/frontend/docs
tessl tile lint skills/frontend/docs
tessl tile publish --dry-run skills/frontend/docs
```

Publishing from GitHub Actions expects a repository secret named `TESSL_TOKEN`. See [docs/distribution.md](docs/distribution.md) for the publish flow and tile naming.
