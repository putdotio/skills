# Scripts

Helpers for local Tessl review loops in this repo.

## Batch review

Run Tessl review across every skill:

```bash
./scripts/review-skills.sh
```

Override the threshold or pass extra review flags:

```bash
TESSL_THRESHOLD=92 ./scripts/review-skills.sh
./scripts/review-skills.sh --threshold 95
```

Batch review does not support `--json`. For structured output, run Tessl directly on one skill:

```bash
npx tessl skill review skills/frontend/docs
npx tessl skill review --json --threshold 90 skills/frontend/repos
```

## Optimize one skill

Apply one Tessl optimization pass to a single skill:

```bash
./scripts/optimize-skills.sh frontend/docs
./scripts/optimize-skills.sh frontend/repos --threshold 92
```

This mutates files. Review the diff before committing.

## Notes

- `collect-publish-tiles.sh` maps changed file paths to tile roots for the publish workflow
- `review-skills.sh` is the batch entrypoint for local skill review
- `optimize-skills.sh` applies mutations, so run it intentionally and inspect the resulting diff
- CI runs `./scripts/review-skills.sh` on pull requests and pushes to `main`
