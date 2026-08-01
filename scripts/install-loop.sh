#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 <codex|openclaw|hermes> <absolute-target-path>" >&2
  exit 2
}

[[ $# -eq 2 ]] || usage

platform="$1"
target="$2"

[[ "$target" = /* ]] || {
  echo "Target must be an absolute path." >&2
  exit 2
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source_root="$(cd "$script_dir/.." && pwd)"

case "$platform" in
  codex|openclaw)
    skill_root="$target/.agents/skills"
    project_root="$target"
    ;;
  hermes)
    skill_root="$target/skills/software-development"
    project_root=""
    ;;
  *) usage ;;
esac

mkdir -p "$skill_root"

for skill in loop-spec loop-build loop-review; do
  if [[ -e "$skill_root/$skill" ]]; then
    echo "Refusing to overwrite existing $skill_root/$skill" >&2
    exit 1
  fi
done

for skill in loop-spec loop-build loop-review; do
  cp -R "$source_root/.agents/skills/$skill" "$skill_root/$skill"
done

if [[ -n "$project_root" ]]; then
  if [[ ! -e "$project_root/.ai-loop.yaml" ]]; then
    cp "$source_root/.ai-loop.example.yaml" "$project_root/.ai-loop.yaml"
  else
    echo "Kept existing $project_root/.ai-loop.yaml"
  fi

  if [[ ! -e "$project_root/AGENTS.md" ]]; then
    cp "$source_root/AGENTS.md" "$project_root/AGENTS.md"
  else
    echo "Kept existing $project_root/AGENTS.md; merge the AI build-loop rules manually."
  fi
fi

echo "Installed loop-spec, loop-build, and loop-review for $platform."
echo "Start a new agent session after configuring the target."
