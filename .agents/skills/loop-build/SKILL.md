---
name: loop-build
description: Claim and implement one approved Linear coding issue, verify it, and open a linked GitHub pull request. Use when asked to build from the approved queue, start or continue the coding loop, or address loop review findings. Do not use for unapproved ideas, explanations, or direct-to-main changes.
---

# Loop Build

One invocation performs one bounded unit: repair one reviewed PR or implement one approved issue. Linear is the work contract; GitHub is the code and review record.

## Preflight

1. Read repository `AGENTS.md` and `.ai-loop.yaml`. Require configured Linear team, GitHub repository, labels, verification commands, and default branch discovery policy.
2. Verify the repository and Linear team are reachable. Detect the real default branch; never assume `main`.
3. Require a clean working tree. If dirty, report paths and stop. Never stash, reset, delete, or absorb unrelated work.
4. Never run two builders for the same Linear team. Use an isolated worktree for any intentional parallel task.

## Repair reviewed work first

Find the least recently updated open PR labeled `loop-changes-requested` and not `needs-human-review`. Read its linked Linear issue and the newest verdict for its current review cycle. Fix only “Must fix before merge” items, run relevant checks, push, remove `loop-changes-requested`, and comment with the evidence. End the invocation.

Count earlier must-fix verdict and repair cycles on the PR. If a fix crosses an `NG-N`, changes an `AC-N`, needs a product decision, or reaches the configured retry limit, add `needs-human-review`, remove it from the automated repair queue, and ask one exact question.

## Pick and claim

If there is no repair work, query the configured Linear team for issues that are all of:

- labeled `agent-ready`;
- unassigned;
- not labeled `blocked`;
- free of unresolved blocker relations.

Sort by priority, then oldest first. If empty, report that and stop. Assign the selected issue to the current authenticated user and move it to the configured started state. Re-fetch it immediately; if it is no longer eligible or is assigned elsewhere, do not work it.

## Enforce the contract

Read the full issue, comments, and relations. Compare every `AC-N` with every `NG-N`. Implement only the stated contract. Do not perform opportunistic refactors. If anything material is ambiguous or contradictory, comment one specific decision question, add `blocked`, unassign the issue, and stop.

## Build and verify

Fetch the latest default branch and create or resume a branch named `ISSUE-ID-short-slug`. Follow repository conventions. Add tests for changed logic, data flow, permissions, integrations, and user-visible behavior.

Run the configured relevant checks: install when needed, tests, lint, type-check, build, and preview/manual verification. Review `git diff` and `git status`. Stop for unrelated changes, generated secrets, or a change that exceeds the issue contract.

## Open the pull request

Push the branch and open one PR containing:

- what changed and why;
- `Closes ISSUE-ID` with the exact Linear identifier;
- one evidence line per `AC-N`;
- one preservation line per `NG-N`;
- `Other behavior changes: None`;
- numbered manual verification steps;
- commands run and results;
- risk level: Low, Medium, or High.

If “Other behavior changes: None” is false, stop and get the Linear contract amended before opening the PR. Comment the PR URL on the Linear issue and move it to the configured review state when present.

Never merge, enable auto-merge, deploy, or apply `loop-approved`. End by reporting that fresh-context review is the next action.
