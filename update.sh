#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "usage: $0 SOURCE_REPO {codex|claude|zoo}..." >&2
}

if [[ $# -lt 1 ]]; then
  usage
  exit 2
fi

source_repo="$1"
shift

update_codex=false
update_claude=false
update_zoo=false
any_update_specified=false

for update_target in "$@"; do
  case "$update_target" in
    codex)
      update_codex=true
      any_update_specified=true
      ;;
    claude)
      update_claude=true
      any_update_specified=true
      ;;
    zoo)
      update_zoo=true
      any_update_specified=true
      ;;
    *)
      echo "error: unknown update target '$update_target'" >&2
      usage
      exit 2
      ;;
  esac
done

if [[ "$any_update_specified" == false ]]; then
  echo "error: specify at least one update target" >&2
  usage
  exit 2
fi

source_codex="$source_repo/.codex"
source_claude="$source_repo/.claude"
source_zoo="$source_repo/.zoo"
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
target_codex="$script_dir/.codex"
target_claude="$script_dir/.claude"
target_zoo="$script_dir/.zoo"

require_dir() {
  if [[ ! -d "$1" ]]; then
    echo "error: '$1' is not a directory" >&2
    exit 1
  fi
}

ensure_distinct_dirs() {
  local source_abs="$1"
  local target_abs="$2"
  local name="$3"

  if [[ "$source_abs" == "$target_abs" ]]; then
    echo "error: source $name and target $name are the same directory" >&2
    exit 1
  fi
}

sync_optional_dir() {
  local source_dir="$1"
  local target_dir="$2"

  rm -rf "$target_dir"
  if [[ -d "$source_dir" ]]; then
    cp -R "$source_dir" "$target_dir"
  fi
}

sync_optional_zoo_skills() {
  local source_skills_dir="$1"
  local target_skills_dir="$2"

  if [[ -d "$target_skills_dir" ]]; then
    find "$target_skills_dir" -mindepth 1 -maxdepth 1 -name 'zoo-*' -exec rm -rf {} +
  fi

  if [[ -d "$source_skills_dir" ]]; then
    mkdir -p "$target_skills_dir"
    shopt -s nullglob
    for skill in "$source_skills_dir"/zoo-*; do
      cp -R "$skill" "$target_skills_dir/"
    done
    shopt -u nullglob
  fi
}

if [[ "$update_codex" == true ]]; then
  require_dir "$source_codex"
  mkdir -p "$target_codex"

  source_codex_abs="$(cd -- "$source_codex" && pwd -P)"
  target_codex_abs="$(cd -- "$target_codex" && pwd -P)"
  ensure_distinct_dirs "$source_codex_abs" "$target_codex_abs" ".codex"

  sync_optional_dir "$source_codex_abs/agents" "$target_codex_abs/agents"
  sync_optional_zoo_skills "$source_codex_abs/skills" "$target_codex_abs/skills"
fi

if [[ "$update_claude" == true ]]; then
  require_dir "$source_claude"
  mkdir -p "$target_claude"

  source_claude_abs="$(cd -- "$source_claude" && pwd -P)"
  target_claude_abs="$(cd -- "$target_claude" && pwd -P)"
  ensure_distinct_dirs "$source_claude_abs" "$target_claude_abs" ".claude"

  sync_optional_dir "$source_claude_abs/agents" "$target_claude_abs/agents"
  sync_optional_dir "$source_claude_abs/commands" "$target_claude_abs/commands"
  sync_optional_zoo_skills "$source_claude_abs/skills" "$target_claude_abs/skills"
fi

if [[ "$update_zoo" == true ]]; then
  require_dir "$source_zoo"
  mkdir -p "$target_zoo"

  source_zoo_abs="$(cd -- "$source_zoo" && pwd -P)"
  target_zoo_abs="$(cd -- "$target_zoo" && pwd -P)"
  ensure_distinct_dirs "$source_zoo_abs" "$target_zoo_abs" ".zoo"

  cp -R "$source_zoo_abs"/. "$target_zoo_abs/"
fi
