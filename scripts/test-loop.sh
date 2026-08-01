#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
test_root="$(mktemp -d)"

cleanup() {
  rm -rf "$test_root"
}
trap cleanup EXIT

python3 "$script_dir/validate-skills.py"
bash -n "$script_dir/install-loop.sh" "$script_dir/test-loop.sh"

for platform in codex openclaw hermes; do
  destination="$test_root/$platform"
  "$script_dir/install-loop.sh" "$platform" "$destination"

  if [[ "$platform" = "hermes" ]]; then
    skill_root="$destination/skills/software-development"
  else
    skill_root="$destination/.agents/skills"
    [[ -f "$destination/AGENTS.md" ]]
    [[ -f "$destination/.ai-loop.yaml" ]]
  fi

  for skill in loop-spec loop-build loop-review; do
    diff -r "$repo_root/.agents/skills/$skill" "$skill_root/$skill"
  done
done

if "$script_dir/install-loop.sh" codex "$test_root/codex"; then
  echo "Installer overwrote an existing skill unexpectedly." >&2
  exit 1
fi

echo "All loop package tests passed."
