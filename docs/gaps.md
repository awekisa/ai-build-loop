# Documentation and implementation gaps

Baseline `ce6567c`, inspected 2026-09-22. These are follow-up proposals, not capabilities claimed by the portfolio documentation. This pass changes documentation only.

## High-value follow-ups

| Gap | Observed basis | Proposed next step |
| --- | --- | --- |
| No complete approval → build → independent review → human merge evidence | Selected run has direct user authorization but no standard readiness transition or review verdict | Capture one small future change with exact issue approval, current-head review, checks, human merge confirmation, and durable links |
| Instruction-level policies can be bypassed | Skills prohibit merges and mandate gates; package has no permission boundary | Define and test host/GitHub permissions separately from the instructions |
| Cross-repository routing is not enforced | Builder filters a Linear team by readiness/assignment/blockers, not a repository field or project | Specify explicit repository validation before claim; test a team containing two repositories |
| Queue claims are not atomic | Assign, move state, re-fetch; no lease/compare-and-set | Define post-claim eligibility precisely and test competing claimers before adding concurrency |
| Configuration and required CI disagree | Local flag false; review always escalates without required checks; live `main` requires `Validate loop package` | Decide whether to remove or define the flag, reconcile config, and validate against settings |
| No full configuration validation | Python script checks skill text/UI prompts, not `.ai-loop.yaml` | Validate required fields, placeholders, commands, states, and labels in a separately scoped change |

The claim instructions also say to re-check eligibility after assigning an issue even though selection eligibility includes being unassigned. The intended ownership check is understandable to an agent, but a deterministic implementation would need distinct pre-claim and post-claim conditions.

## Failure handling and review gaps

- **Repair accounting:** default is two reviewed repair rounds, counted from PR history. The exact boundary and behavior with missing/edited history need tests. It is not a general budget for local tool failures.
- **Crash and uncertain-write recovery:** no general algorithm handles a crash between claim, push, PR creation, and Linear update, or a timeout after a successful remote mutation.
- **Review state:** the reviewer is instructed to recheck head and use fresh context; no service enforces independence, automatically removes stale approval labels, or guarantees another invocation after a changed head.
- **Human-gate re-entry:** review selection can skip a SHA that already has a terminal verdict label, while `needs-human-review` is meant to stop automation until a human resolves it. A tested re-entry procedure should reconcile the queue-selection and preserve-gate rules.
- **Required-check detail:** pending checks, absent required CI, failure, and conflicts are covered by instructions. Rulesets, optional checks, stale verdicts, and scope conflicts have no behavioral fixture tests in this repository.

## Packaging and portability gaps

- Three copy layouts are tested, but live skill discovery and full spec/build/review behavior are not tested on all hosts.
- Hermes receives skills only; users must configure the target repository separately. Documentation now states this explicitly.
- The example still has the author-specific Linear team key. Project identification and repository routing must not be inferred from that key.
- Installer conflict detection prevents ordinary overwrites but installation is not transactional. Upgrades, interrupted-copy recovery, preservation of pre-existing config contents, invalid platform/path inputs, and repeat installs on every host need more coverage before stronger reliability claims.
- The phrase-based validator proves selected text exists, not that an agent obeys it or that every YAML file parses correctly.
- Voice and scheduling are external host facilities; no built-in scheduler, voice parser, hosting backend, or deployment integration is implemented.

## Documentation/evidence still to collect

1. Public, durable evidence for every human-control gate in a single run. A retrospective account should not substitute for missing approval.
2. A reviewed repair-cycle example with before/after SHAs and a verdict for the final head. The current demo's local test correction is not an independent-review repair cycle.
3. Versioned compatibility results for each supported host, including setup and credential requirements.
4. An owner-selected license and confirmed upstream notice obligations.
5. Metrics from repeatable observations, if claims about speed, cost, or reliability are desired. None are asserted now.

No architecture rewrite is required to explain the current system. Each proposed implementation change should have its own specification and approval before build work.
