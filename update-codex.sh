#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: $0 SOURCE_REPO" >&2
  exit 2
fi

source_codex="$1/.codex"
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
target_codex="$script_dir/.codex"

if [[ ! -d "$source_codex" ]]; then
  echo "error: '$source_codex' is not a directory" >&2
  exit 1
fi

if [[ ! -d "$source_codex/agents" ]]; then
  echo "error: '$source_codex/agents' is not a directory" >&2
  exit 1
fi

if [[ ! -d "$source_codex/skills" ]]; then
  echo "error: '$source_codex/skills' is not a directory" >&2
  exit 1
fi

mkdir -p "$target_codex/skills"

source_codex_abs="$(cd -- "$source_codex" && pwd -P)"
target_codex_abs="$(cd -- "$target_codex" && pwd -P)"

if [[ "$source_codex_abs" == "$target_codex_abs" ]]; then
  echo "error: source .codex and target .codex are the same directory" >&2
  exit 1
fi

rm -rf "$target_codex_abs/agents"
cp -R "$source_codex_abs/agents" "$target_codex_abs/agents"

find "$target_codex_abs/skills" -mindepth 1 -maxdepth 1 -name 'zoo-*' -exec rm -rf {} +

shopt -s nullglob
for skill in "$source_codex_abs"/skills/zoo-*; do
  cp -R "$skill" "$target_codex_abs/skills/"
done
