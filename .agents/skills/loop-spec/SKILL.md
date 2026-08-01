---
name: loop-spec
description: Research a codebase, interview the user, and create a build-ready Linear issue contract. Use for feature ideas, bugs, refactors, or other proposed code changes before implementation. Interactive only; do not use for explanations or standalone code snippets, and never approve the resulting issue automatically.
---

# Loop Spec

Turn a raw coding request into one unambiguous, one-pass Linear issue. Treat the user as the product authority and the repository as the technical authority.

## Preflight

1. Find the repository root and read `AGENTS.md` plus `.ai-loop.yaml`. If the configuration is absent, draft it from `.ai-loop.example.yaml` and ask the user to confirm missing values before creating an issue.
2. Verify the configured GitHub repository and Linear team are readable. Use the available Linear connector/app and `gh` CLI or an equivalent authenticated GitHub connector.
3. Do not edit code, create branches, or apply readiness labels in this skill.

## Research before asking

Inspect relevant files, tests, history, and project conventions. Do not ask questions the repository can answer. Identify likely affected files, existing patterns, constraints, and verification commands.

## Interview in short rounds

Ask one to four genuine product questions per round, with concrete options and a recommendation when appropriate. Resolve:

- observable behavior and affected users;
- explicit scope boundaries;
- permissions, empty states, failure behavior, and migrations when relevant;
- verification that a person can perform;
- dependencies and rollout risks.

After each round ask internally: could two engineers independently ship the same observable result from this contract? Continue until the answer is yes. Voice responses may be terse; repeat back identifiers and consequential choices before acting.

## Draft the contract

Use this exact issue body shape:

```md
## Problem

One or two sentences describing the user or business outcome.

## Acceptance Criteria

- [ ] AC-1 — Observable, testable outcome

## Non-goals

- NG-1 — Behavior explicitly excluded from this change

## Constraints and risks

- Technical, product, security, data, or rollout constraints

## Relevant files

- `path/to/file` — why it matters

## Test expectations

- Automated checks and cases required

## How to verify

1. A reproducible manual step covering one or more acceptance criteria

## Dependencies

- Blocking issues, services, migrations, or `None`
```

Give every acceptance criterion and non-goal a stable `AC-N` or `NG-N` identifier. Make acceptance criteria observable. Ensure no acceptance criterion requires a non-goal. Split work larger than one focused agent pass into ordered issues with explicit blocker relations.

## Confirm and file

Show the complete draft and obtain explicit approval to create it. For voice, require the user to confirm the proposed title and say that the issue should be created. Create the issue in the configured Linear team, then return its exact identifier and URL.

Do not apply `agent-ready`. The user must separately approve the filed contract. If the user explicitly says `Approve spec ISSUE-ID` in a later instruction, the Linear integration may apply `agent-ready` only after re-reading that exact issue and repeating its title. Never infer approval from enthusiasm, issue creation, or a generic “go ahead.”

## End state

Report the next human action first: review the Linear issue and either request changes or explicitly approve that exact identifier. Do not start implementation from this skill.
