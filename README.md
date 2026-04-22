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

Publishing from GitHub Actions expects a repository secret named `TESSL_TOKEN`. See [Distribution](docs/distribution.md) for the publish flow and tile naming.

## Publishable skill shape

Public skills in this repo should keep their package metadata next to the skill:

- `SKILL.md` is the skill body and activation contract
- `tile.json` is the Tessl package and publish metadata
- `agents/openai.yaml` sets picker-facing OpenAI or Codex display names, descriptions, and default prompts when the default fallback naming is not good enough

Keep those files aligned when adding or renaming a published skill.

## Docs

- [Contributing](./CONTRIBUTING.md) for contributor workflow and validation
- [Distribution](./docs/distribution.md) for publish flow and repository release details
- [Security](./SECURITY.md) for private vulnerability reporting

## Repo Internals

- [Agent guide](./AGENTS.md) for repo-specific automation guidance
- [Scripts reference](./scripts/README.md) for helper script notes

## Contributing

Use [Contributing](./CONTRIBUTING.md) for skill-authoring workflow and review expectations.
