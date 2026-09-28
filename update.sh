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
source_agents="$source_repo/.agents"
source_zoo="$source_repo/.zoo"
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
target_codex="$script_dir/.codex"
target_claude="$script_dir/.claude"
target_agents="$script_dir/.agents"
target_zoo="$script_dir/.zoo"

managed_skill_names=(zoo terse linus)
managed_skill_prefixes=(zoo)

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

remove_managed_skills() {
  local target_skills_dir="$1"
  local name
  local prefix

  if [[ ! -d "$target_skills_dir" ]]; then
    return 0
  fi

  for name in "${managed_skill_names[@]}"; do
    rm -rf "$target_skills_dir/$name"
  done
  for prefix in "${managed_skill_prefixes[@]}"; do
    find "$target_skills_dir" -mindepth 1 -maxdepth 1 -name "$prefix-*" -exec rm -rf {} +
  done
}

sync_optional_project_skills() {
  local source_skills_dir="$1"
  local target_skills_dir="$2"
  local name
  local prefix
  local skill

  remove_managed_skills "$target_skills_dir"

  if [[ -d "$source_skills_dir" ]]; then
    mkdir -p "$target_skills_dir"
    for name in "${managed_skill_names[@]}"; do
      if [[ -e "$source_skills_dir/$name" ]]; then
        cp -R "$source_skills_dir/$name" "$target_skills_dir/"
      fi
    done
    shopt -s nullglob
    for prefix in "${managed_skill_prefixes[@]}"; do
      for skill in "$source_skills_dir"/"$prefix"-*; do
        cp -R "$skill" "$target_skills_dir/"
      done
    done
    shopt -u nullglob
  fi
}

# Skills are shared regardless of which harness's agents are being updated.
if [[ "$update_codex" == true || "$update_claude" == true ]]; then
  require_dir "$source_agents/skills"
  mkdir -p "$target_agents"
  source_agents_abs="$(cd -- "$source_agents/skills" && pwd -P)"
  target_agents_abs="$(mkdir -p "$target_agents/skills" && cd -- "$target_agents/skills" && pwd -P)"
  ensure_distinct_dirs "$source_agents_abs" "$target_agents_abs" "skills"
  sync_optional_project_skills "$source_agents_abs" "$target_agents_abs"
fi

if [[ "$update_codex" == true ]]; then
  require_dir "$source_codex"
  mkdir -p "$target_codex"

  source_codex_abs="$(cd -- "$source_codex" && pwd -P)"
  target_codex_abs="$(cd -- "$target_codex" && pwd -P)"
  ensure_distinct_dirs "$source_codex_abs" "$target_codex_abs" ".codex"

  sync_optional_dir "$source_codex_abs/agents" "$target_codex_abs/agents"
  remove_managed_skills "$target_codex_abs/skills"
fi

if [[ "$update_claude" == true ]]; then
  require_dir "$source_claude"
  mkdir -p "$target_claude"

  source_claude_abs="$(cd -- "$source_claude" && pwd -P)"
  target_claude_abs="$(cd -- "$target_claude" && pwd -P)"
  ensure_distinct_dirs "$source_claude_abs" "$target_claude_abs" ".claude"

  sync_optional_dir "$source_claude_abs/agents" "$target_claude_abs/agents"
  sync_optional_dir "$source_claude_abs/commands" "$target_claude_abs/commands"
fi

if [[ "$update_zoo" == true ]]; then
  require_dir "$source_zoo"
  mkdir -p "$target_zoo"

  source_zoo_abs="$(cd -- "$source_zoo" && pwd -P)"
  target_zoo_abs="$(cd -- "$target_zoo" && pwd -P)"
  ensure_distinct_dirs "$source_zoo_abs" "$target_zoo_abs" ".zoo"

  cp -R "$source_zoo_abs"/. "$target_zoo_abs/"
fi
