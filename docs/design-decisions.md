# Design decisions

These explanations are grounded in the implementation and history. They are not retrospective claims about undocumented author intent.

## Separate specification from implementation

**Decision:** `loop-spec` researches and interviews, but cannot edit code or create branches. It files the contract only after approval and cannot mark it ready itself.

**Reasoning and tradeoff:** a person can inspect scope before execution; stable `AC-N` and `NG-N` identifiers connect implementation to review. Specification needs an available human. Material contract changes require renewed approval rather than side-channel instructions.

**Evidence:** [spec skill](../.agents/skills/loop-spec/SKILL.md), [routing rules](../AGENTS.md).

## Keep final merge under human control

**Decision:** builders and reviewers cannot merge, enable auto-merge, or deploy. A passing reviewer supplies evidence for a human decision.

**Reasoning and tradeoff:** satisfying configured checks and accepting the result's remaining risk are separate actions. These are instruction-level controls; the package does not remove merge permission from credentials or provision GitHub protection.

**Evidence:** [build](../.agents/skills/loop-build/SKILL.md), [review](../.agents/skills/loop-review/SKILL.md), [policy](../.ai-loop.example.yaml).

## Persist context in the work systems

**Decision:** Linear holds scope and queue state; GitHub holds code, CI, review evidence, and merge state. Conversation is a control surface.

**Reasoning and tradeoff:** fresh sessions reconstruct work from durable artifacts rather than the builder's memory. Both services must remain accessible. No transaction spans Linear assignment and GitHub PR creation, and approval does not freeze the issue body.

**Evidence:** [workflow authorities](workflow.md), build handoff requirements.

## Put repository variation in context and configuration

**Decision:** copy the same skills to targets; read target instructions, commands, and identifiers. Identify GitHub as `owner/repository` and discover its actual default branch.

**Reasoning and tradeoff:** application-specific paths/checks remain with the application. The explicit repository avoids trusting a Linear team's mirror destination. Configuration remains host-interpreted; there is no enforced issue-to-repository routing, and the example team must be replaced.

**Evidence:** [installer](../scripts/install-loop.sh), [configuration](../.ai-loop.example.yaml), build preflight, and the [demo's routing issue](demo/README.md).

## Use Linear as a queue, with one bounded unit per pass

**Decision:** one issue per PR, one builder per team, repairs before new work, and blocker relations for dependencies.

**Reasoning and tradeoff:** small units bound review scope; repair priority keeps unfinished changes moving. Team-wide serialization limits concurrency and relies on operator discipline. Assign-and-re-fetch is not an atomic lock.

**Evidence:** build selection/repair rules; `one_builder_per_linear_team: true`.

## Review a specific commit in separate context

**Decision:** the reviewer cannot be the builder conversation. It reads the contract and diff, records the SHA, verifies required checks and mergeability, and rechecks the head before posting.

**Reasoning and tradeoff:** separate context reduces reliance on the builder's assumptions, while a versioned verdict avoids approving later edits accidentally. The host must create the context and invoke review again; no service verifies independence or automatically invalidates stale labels.

**Evidence:** review selection and merge-evidence rules.

## Bound repairs and persist escalation

**Decision:** repair must-fix findings inside scope; escalate scope conflicts, missing required checks, and repair-budget exhaustion. Preserve `needs-human-review` until a human resolves it.

**Reasoning and tradeoff:** failure must not silently change the goal or trigger indefinite work. Repair count comes from PR history, and crash/API recovery is not fully specified. The default of two fix rounds is policy rather than an implemented retry engine.

**Evidence:** build repair rules, review label rules, `max_fix_rounds: 2`.

## Preserve target files during installation

**Decision:** refuse existing skill directories and retain existing target configuration/instructions. Install and test with Bash/Python and standard tools.

**Reasoning and tradeoff:** adoption should preserve the application's conventions, and package checks should not require service credentials. Reconciliation/upgrades remain manual; interrupted installation has no rollback and live host behavior is outside the tests.

**Evidence:** [installer](../scripts/install-loop.sh), [package tests](../scripts/test-loop.sh).

## History boundary

The initial commit [`36763ae`](https://github.com/awekisa/ai-build-loop/commit/36763ae8518fbe50a12e9fa0b20651a4a7e6632c) introduced the roles and policies. [`3fcff47`](https://github.com/awekisa/ai-build-loop/commit/3fcff4758e5324c30ed9c0fa46d63f01dbcb9c9d) updated the checkout action. [`ce6567c`](https://github.com/awekisa/ai-build-loop/commit/ce6567c886732da67189967571958ac7ddc298b7) documented required-check fallback and set the local flag to false. The review skill still escalates without required checks; this documentation records the inconsistency rather than inventing a new policy.
