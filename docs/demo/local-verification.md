# Reproduce the package verification

This demonstrates the repository's executable installer and validator. It does not simulate an approved Linear issue, invoke live agents, or prove the full development loop.

## Run

Requirements: Git, Bash, Python 3, and standard Unix tools such as `mktemp`, `cp`, and `diff`.

```bash
git clone https://github.com/awekisa/ai-build-loop.git
cd ai-build-loop
./scripts/test-loop.sh
```

The test uses temporary target directories and removes them when it finishes. It installs no dependencies, contacts no external service, and does not alter an existing agent installation.

## Observed result

Executed on macOS on 2026-09-22 at baseline `ce6567c886732da67189967571958ac7ddc298b7`. Exit status: **0**. Output below preserves the messages; only the temporary absolute directory is normalized.

```text
loop-spec: valid
loop-build: valid
loop-review: valid
Installed loop-spec, loop-build, and loop-review for codex.
Start a new agent session after configuring the target.
Installed loop-spec, loop-build, and loop-review for openclaw.
Start a new agent session after configuring the target.
Installed loop-spec, loop-build, and loop-review for hermes.
Start a new agent session after configuring the target.
Refusing to overwrite existing <temporary-directory>/codex/.agents/skills/loop-spec
All loop package tests passed.
```

The refusal is an expected negative check: a second Codex installation must fail rather than overwrite the existing skills.

## What the check proves

- The three skill files contain the required structure and selected policy phrases, and each UI prompt invokes its matching skill.
- The installer/test shell syntax parses.
- The three platform layouts receive identical skill copies.
- Codex/OpenClaw targets receive `AGENTS.md` and `.ai-loop.yaml` when absent.
- A repeated Codex installation is refused.

It does not validate the full YAML configuration, exercise live Linear/GitHub calls, establish model compliance, test every installer failure path, or prove all hosts can discover and execute the skills.

Historical public CI for this package also passed at the audited baseline: [Validate run 30701573472](https://github.com/awekisa/ai-build-loop/actions/runs/30701573472).
