#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: ./scripts/optimize-skills.sh <group/name> [extra tessl args...]"
  exit 1
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

skill_name="$1"
shift

skill_dir="skills/$skill_name"

if [[ ! -d "$skill_dir" ]]; then
  echo "skill not found: $skill_dir"
  exit 1
fi

npx tessl skill review --optimize --yes --max-iterations 1 "$skill_dir" "$@"
