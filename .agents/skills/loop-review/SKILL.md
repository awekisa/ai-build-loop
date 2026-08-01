---
name: loop-review
description: Independently review one GitHub pull request against its linked Linear issue, required checks, and current head commit, then post a structured verdict and loop label. Use for the review queue or after a loop-build PR changes. Never edit code, push, merge, or expand scope.
---

# Loop Review

Review one eligible PR in fresh context. The reviewer must not be the builder conversation. Linear defines scope; the current GitHub head and required checks define merge evidence.

If the current conversation built or repaired the selected PR, stop and launch or request a separate fresh task that invokes `loop-review`. Do not simulate independence inside the builder context.

## Select one PR

Read `AGENTS.md` and `.ai-loop.yaml`. List open, non-draft PRs. For each, find the newest comment beginning `Loop review of COMMIT_SHA`.

Skip a PR when that SHA equals the current head and it already has one of `loop-approved`, `loop-changes-requested`, or `needs-human-review`. Re-review whenever the head changes. Select the least recently updated eligible PR. If none exists, report an empty queue and stop.

## Read the contract and change

Parse the exact Linear identifier from `Closes ISSUE-ID` in the PR body. Missing linkage is a must-fix finding. Fetch the full issue, comments, and relations. Read the complete diff and changed files in context.

Review only for:

- unmet `AC-N` outcomes;
- violations of `NG-N` boundaries;
- defects in the changed behavior or data flow;
- security problems;
- missing loading, empty, permission, or failure states required by the contract;
- unnecessary scope expansion;
- required verification or maintainability gaps inside scope.

Prefix every must-fix item with `[AC-N]`, `[DEFECT]`, `[SECURITY]`, or `[CI]`. If a fix would contradict an `NG-N`, record `[SCOPE-CONFLICT AC-N ↔ NG-N]` and escalate rather than prescribing code. Do not turn unrelated improvements into required work.

## Verify merge evidence

Record the exact current head SHA. Inspect mergeability and required GitHub checks.

- If checks or mergeability are pending or unknown, report “waiting” without changing labels.
- Treat a failed required check as `[CI]`.
- Treat a merge conflict as `[DEFECT]`.
- If no required checks exist, apply `needs-human-review`; missing CI is not green.
- Re-fetch the head immediately before posting. If it changed, discard the review.

## Post one verdict

Use this structure:

```md
Loop review of COMMIT_SHA

CI: required checks passed | failed | not configured
Mergeability: clean | conflicting

## Review

Summary: one or two plain-language sentences.

## 1. Must fix before merge

None, or numbered findings with file and line evidence.

## 2. Should fix soon

None, or non-blocking items inside the contract.

## 3. Safe to merge

Yes — evidence is complete; a human still decides. | No — reason.
```

Apply labels idempotently:

- pass with required CI and clean merge: add `loop-approved`, remove `loop-changes-requested`;
- must-fix: add `loop-changes-requested`, remove `loop-approved`;
- scope conflict or missing required CI: add `needs-human-review`, remove both automated verdict labels.

Preserve an existing `needs-human-review` gate unless a human explicitly resolved and removed it. Never use formal self-review APIs when GitHub would reject the author’s own review; use a comment and labels.

Never edit code, push, merge, enable auto-merge, or deploy. Report the exact next human action first.
