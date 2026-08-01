#!/usr/bin/env python3
"""Validate the portable loop skill package without third-party dependencies."""

from __future__ import annotations

import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
SKILLS = {
    "loop-spec": ("agent-ready", "Linear issue", "explicit approval"),
    "loop-build": ("agent-ready", "loop-changes-requested", "Never merge"),
    "loop-review": ("loop-approved", "required GitHub checks", "fresh context"),
}


def fail(message: str) -> None:
    print(f"ERROR: {message}", file=sys.stderr)
    raise SystemExit(1)


for expected_name, required_phrases in SKILLS.items():
    skill_dir = ROOT / ".agents" / "skills" / expected_name
    skill_path = skill_dir / "SKILL.md"
    ui_path = skill_dir / "agents" / "openai.yaml"

    if not skill_path.is_file() or not ui_path.is_file():
        fail(f"{expected_name}: missing SKILL.md or agents/openai.yaml")

    content = skill_path.read_text(encoding="utf-8")
    match = re.match(r"^---\n(.*?)\n---", content, re.DOTALL)
    if not match:
        fail(f"{expected_name}: invalid YAML frontmatter boundary")

    frontmatter = match.group(1).splitlines()
    fields = {}
    for line in frontmatter:
        key, separator, value = line.partition(":")
        if not separator:
            fail(f"{expected_name}: malformed frontmatter line: {line}")
        fields[key.strip()] = value.strip()

    if set(fields) != {"name", "description"}:
        fail(f"{expected_name}: frontmatter must contain only name and description")
    if fields["name"] != expected_name:
        fail(f"{expected_name}: name does not match directory")
    if not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", fields["name"]):
        fail(f"{expected_name}: invalid skill name")
    if not fields["description"] or len(fields["description"]) > 1024:
        fail(f"{expected_name}: invalid description")
    if "<" in fields["description"] or ">" in fields["description"]:
        fail(f"{expected_name}: description contains an angle bracket")

    for phrase in required_phrases:
        if phrase not in content:
            fail(f"{expected_name}: missing required policy phrase {phrase!r}")

    ui = ui_path.read_text(encoding="utf-8")
    if f"${expected_name}" not in ui:
        fail(f"{expected_name}: default UI prompt does not invoke the skill")

    print(f"{expected_name}: valid")
