#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "usage: $0 TARGET_PROJECT_DIR" >&2
}

if [[ $# -ne 1 ]]; then
  usage
  exit 2
fi

target_project="$1"
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -d "$target_project" ]]; then
  echo "error: '$target_project' is not a directory" >&2
  exit 1
fi

source_abs="$(cd -- "$script_dir" && pwd -P)"
target_abs="$(cd -- "$target_project" && pwd -P)"

if [[ "$source_abs" == "$target_abs" ]]; then
  echo "error: target project is this repository" >&2
  exit 1
fi

managed_skill_names=(zoo terse linus)
managed_skill_prefixes=(zoo)
managed_agent_prefixes=(zoo)

copy_named_children() {
  local source_dir="$1"
  local target_dir="$2"
  local label="$3"
  local entry
  local name

  if [[ ! -d "$source_dir" ]]; then
    echo "error: missing source $label directory '$source_dir'" >&2
    exit 1
  fi

  mkdir -p "$target_dir"

  shopt -s nullglob
  for entry in "$source_dir"/*; do
    name="$(basename -- "$entry")"
    rm -rf "$target_dir/$name"
    cp -R "$entry" "$target_dir/"
  done
  shopt -u nullglob
}

remove_managed_skills() {
  local target_dir="$1"
  local name
  local prefix

  if [[ ! -d "$target_dir" ]]; then
    return 0
  fi

  for name in "${managed_skill_names[@]}"; do
    rm -rf "$target_dir/$name"
  done

  for prefix in "${managed_skill_prefixes[@]}"; do
    find "$target_dir/" -mindepth 1 -maxdepth 1 -name "$prefix-*" -exec rm -rf {} +
  done
}

# remove_managed_agents drops agents upstream no longer ships (e.g. retired
# zoo-check-*); copying alone would leave them registered in the target.
remove_managed_agents() {
  local target_dir="$1"
  local prefix

  if [[ ! -d "$target_dir" ]]; then
    return 0
  fi

  for prefix in "${managed_agent_prefixes[@]}"; do
    find "$target_dir/" -mindepth 1 -maxdepth 1 -name "$prefix-*" -exec rm -rf {} +
  done
}

copy_managed_skills() {
  local source_dir="$1"
  local target_dir="$2"
  local label="$3"
  local name
  local prefix
  local skill

  if [[ ! -d "$source_dir" ]]; then
    echo "error: missing source $label directory '$source_dir'" >&2
    exit 1
  fi

  mkdir -p "$target_dir"
  remove_managed_skills "$target_dir"

  for name in "${managed_skill_names[@]}"; do
    if [[ -e "$source_dir/$name" ]]; then
      cp -R "$source_dir/$name" "$target_dir/"
    fi
  done

  shopt -s nullglob
  for prefix in "${managed_skill_prefixes[@]}"; do
    for skill in "$source_dir"/"$prefix"-*; do
      name="$(basename -- "$skill")"
      rm -rf "$target_dir/$name"
      cp -R "$skill" "$target_dir/"
    done
  done
  shopt -u nullglob
}

copy_managed_skills "$source_abs/.agents/skills" "$target_abs/.agents/skills" ".agents skills"
remove_managed_skills "$target_abs/.codex/skills"
remove_managed_agents "$target_abs/.codex/agents"
copy_named_children "$source_abs/.codex/agents" "$target_abs/.codex/agents" ".codex agents"
copy_managed_skills "$source_abs/.claude/skills" "$target_abs/.claude/skills" ".claude skills"
remove_managed_agents "$target_abs/.claude/agents"
copy_named_children "$source_abs/.claude/agents" "$target_abs/.claude/agents" ".claude agents"

echo "Installed. Now run Zoo Init from that project."
