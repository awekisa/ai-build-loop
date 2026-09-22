# Portfolio summary

## One-line description

Designed an AI-assisted development workflow that turns scoped Linear contracts into tested GitHub pull requests, with separate specification, build, and review roles and explicit human approval boundaries.

## 30-second explanation

AI Build Loop addresses the coordination around AI-generated code: deciding what should change, carrying context across sessions, validating the result, and knowing when automation must stop. I adapted and packaged three portable agent skills for specification, implementation, and independent review. Linear stores the work contract; GitHub stores code and verification evidence. The workflow reserves specification approval, scope decisions, and merge for a human. The repository includes an installer, package checks, and a real feature case study that documents both successful execution and gaps in process compliance.

## Technical highlights

- Stable acceptance-criterion and non-goal identifiers link specification to PR evidence and review findings.
- Build passes prioritize repairs and otherwise select one ready, unblocked issue with dependencies resolved.
- Review instructions bind verdicts to a commit SHA, required checks, and mergeability, and require a separate context.
- A configurable repair budget and persistent escalation labels identify when a human decision is needed.
- Repository-specific identifiers and commands are separated from reusable workflow instructions.
- Bash/Python package tests cover skill structure, three installation layouts, and refusal to overwrite existing skills.

## What I designed

The adaptation and packaging of the workflow: role boundaries, issue/PR contracts, repository configuration, host installation paths, validation, and human handoffs. The original project credits Finn-loop as its starting point; the contribution should be described as an adaptation, not as inventing every underlying idea.

The engineering surface is a portable workflow package. It does not contain a custom LLM, model training pipeline, agent runtime, or distributed orchestration service.

## What the agents do

Research code and conventions, clarify requirements, draft issue contracts, implement bounded changes, run project checks, diagnose failures, prepare linked PRs, and inspect changes in a separate review context. Repairs must remain inside the approved contract; ambiguity or exhausted repair budget requires escalation.

## What remains under human control

Intent, specification approval, important architecture/scope choices, resolution of blocked work, acceptance of remaining risk, and final merge. These boundaries are expressed in instructions and external settings rather than fully enforced by package code.

## Technologies

**This package:** Markdown agent skills, YAML configuration and UI metadata, Bash installation/tests, Python structural validation, Git, GitHub CLI or equivalent connector, GitHub Actions, Linear connectors. Install layouts target Codex, OpenClaw, and Hermes.

**Downstream demonstration:** .NET, PostgreSQL, React/TypeScript, xUnit, and Cypress in PredictionsProject. Those are the target application's stack, not an embedded runtime in AI Build Loop.

## Interesting engineering problems

- Keeping a specification stable while an agent discovers implementation details.
- Passing sufficient context to a fresh reviewer without relying on the builder's narrative.
- Preventing stale approval after the PR head changes.
- Routing work correctly when a Linear team spans repositories or mirrors issues elsewhere.
- Separating a successful CI run from approval to merge.
- Recovering from failures without silently expanding scope or retrying indefinitely.

## Evidence

The [case study](demo/README.md) traces a real scoped-token feature from request and task decomposition to [PR #32](https://github.com/awekisa/PredictionsProject/pull/32). Public CI records **63 backend tests and 36 browser tests passing** for that PR. The local execution record shows a test-host mismatch and autonomous correction. These counts describe the target application's verification, not a measured productivity gain or the number of tests in this package.

## Current limitations

No complete, publicly verifiable run of every approval/review gate is captured. The example used direct human authorization without the standard readiness label; independent loop review and the exact human merge action are unverified. The package lacks atomic queue claims, enforced repository routing, general crash recovery, full configuration validation, and end-to-end tests across the three hosts. There are no substantiated speed/cost/reliability metrics. See [implementation gaps](gaps.md).
