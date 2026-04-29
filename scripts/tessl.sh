#!/usr/bin/env bash
set -euo pipefail

if command -v tessl >/dev/null 2>&1; then
  exec tessl "$@"
fi

exec npx tessl "$@"
