#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"
tessl_cmd=("$repo_root/scripts/tessl.sh")

threshold="${TESSL_THRESHOLD:-90}"
args=()

has_threshold=false
has_json=false
for arg in "$@"; do
  if [[ "$arg" == "--threshold" ]] || [[ "$arg" == --threshold=* ]]; then
    has_threshold=true
  fi
  if [[ "$arg" == "--json" ]]; then
    has_json=true
  fi
done

if [[ "$has_json" == true ]]; then
  echo "batch review does not support --json; run ./scripts/tessl.sh skill review --json skills/<group>/<name> per skill"
  exit 1
fi

if [[ "$has_threshold" == false ]]; then
  args+=(--threshold "$threshold")
fi

args+=("$@")

while IFS= read -r skill_md; do
  skill_dir="$(dirname "$skill_md")"
  echo "== tessl review: ${skill_dir#skills/} =="
  "${tessl_cmd[@]}" skill review "${args[@]}" "$skill_dir"
done < <(find skills -mindepth 3 -maxdepth 3 -name SKILL.md | sort)
