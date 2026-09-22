# Demonstration: revocable account access for agents

An application owner wanted Codex and Hermes to use the Predictions app as their existing account. The first feature gave the owner separately named, scoped, expiring credentials that could be revoked without changing their password. This case study follows that feature through real work records and a public pull request.

**Result:** [PredictionsProject PR #32](https://github.com/awekisa/PredictionsProject/pull/32), with six acceptance criteria mapped to evidence, **63 backend tests and 36 browser tests passing in CI**, and a recorded merge. **Evidence limit:** this is an observed spec/build run with process deviations, not proof that every prescribed loop gate was followed.

## Source boundaries

The public PR, commit diff, checks, and merge metadata are independently inspectable. The owner's connected Linear records and local Codex task named **MCP for predictions app**, dated 2026-09-21, were also inspected during this audit. Selected technical excerpts are reproduced in [execution-excerpts.md](execution-excerpts.md); local paths, credentials, unrelated conversation, and private repository identifiers are omitted. That local record is not a public, independently authenticated transcript.

The downstream task explicitly loaded the owner's installed `loop-spec` and `loop-build` skills. The reviewed target commit did not contain `.ai-loop.yaml`. This demonstrates use of those installed workflows, not proof that this package's exact baseline was installed in the target or that its standard queue was used.

## 1. Initial request and human choices

The owner requested a Linear task for an MCP connection acting as their existing user account. During specification, they chose both prediction and existing admin actions and identified Codex and Hermes as the intended clients. The agent proposed account-created, revocable credentials and split the work into dependencies before implementation.

**Source:** local specification conversation; the resulting public PRs describe the same scope. The original conversation is summarized rather than published in full.

## 2. Generated specification and approval boundary

The first contract was [SME-99](https://linear.app/smeagol-hermes/issue/SME-99), “Add scoped, revocable MCP access tokens to account settings.” Linear access may be needed to open it. Its public-facing scope can also be checked against PR #32's acceptance evidence.

| Criterion | Contract summary | Implementation evidence |
| --- | --- | --- |
| AC-1 | Named connections, expiry selection, one-time secret display, listing and revocation | Account settings UI and Cypress coverage |
| AC-2 | Independent read/write/admin scopes, conservative default, current-admin restriction | Scope definitions, UI, service and HTTP tests |
| AC-3 | At least 256 bits of entropy, hash-only storage, account ownership | Token service, entity/configuration and ownership tests |
| AC-4 | Validate current account, expiry/revocation and live admin role | Dedicated authentication and authorization tests |
| AC-5 | Revocation takes effect on the next request; tokens cannot mint tokens or access ordinary REST routes | Retained-principal and scheme-isolation tests |
| AC-6 | Migration, regression tests, failure states, no later secret disclosure | PostgreSQL migration checks, HTTP and browser cases |

Non-goals kept the MCP endpoint/tools, OAuth, agent-issued credentials, password/role changes, impersonation, and paid identity services outside this feature. The broader endpoint and admin capability belonged to later issues.

**Observed approval:** after task creation, the owner instructed implementation. The agent explicitly said it would proceed with that instruction while leaving automated readiness unchanged. The retrieved issue had no `agent-ready` label. This is direct human authorization, not evidence of the standard separate `Approve spec ISSUE-ID` readiness gate. No retrospective label or approval was added for this demonstration.

## 3. Tasks created

| Ordered task | Responsibility | Public result |
| --- | --- | --- |
| SME-99 | Account-owned access credentials | [PR #32](https://github.com/awekisa/PredictionsProject/pull/32) — this demonstration |
| SME-100 | Authenticated fixtures, standings and prediction tools | [PR #33](https://github.com/awekisa/PredictionsProject/pull/33) |
| SME-101 | Role-checked admin tools and client verification | [PR #34](https://github.com/awekisa/PredictionsProject/pull/34) |

The parent was SME-98. The inspected relation shows SME-99 blocking SME-100. Linear's team-level GitHub mirror pointed to a different repository; the specification explicitly identified PredictionsProject as the code target. This is evidence for verifying repository identity rather than deriving it from a team or mirror.

## 4. Agent implementation

The local task records the agent loading `loop-build`, finding unrelated edits in an existing checkout, and using a separate clean checkout. It implemented the credential entity/service/controller, authentication checks, account-settings UI, migration, and tests, then committed and opened a PR.

The public implementation is pinned to [`be5db872a8bcc60c7af1bcc971d39bb9d04489cf`](https://github.com/awekisa/PredictionsProject/commit/be5db872a8bcc60c7af1bcc971d39bb9d04489cf). Representative files:

- [Token service](https://github.com/awekisa/PredictionsProject/blob/be5db872a8bcc60c7af1bcc971d39bb9d04489cf/PredictionsAPI/Services/Implementations/McpAccessTokenService.cs).
- [Account connections UI](https://github.com/awekisa/PredictionsProject/blob/be5db872a8bcc60c7af1bcc971d39bb9d04489cf/predictions-ui/src/components/account/AgentConnections.tsx).
- [HTTP authorization tests](https://github.com/awekisa/PredictionsProject/blob/be5db872a8bcc60c7af1bcc971d39bb9d04489cf/PredictionsAPI.Tests/McpAuthenticationIntegrationTests.cs).
- [Browser tests](https://github.com/awekisa/PredictionsProject/blob/be5db872a8bcc60c7af1bcc971d39bb9d04489cf/predictions-ui/cypress/e2e/agent-connections.cy.ts).

These artifacts establish what changed. Attribution to agent execution comes from the local task's recorded edits/commands; Git commit authorship by itself does not establish that.

## 5. Validation

| Evidence | Result | Source |
| --- | --- | --- |
| Backend CI | 63 passed | [Backend Tests job](https://github.com/awekisa/PredictionsProject/actions/runs/35569052700/job/106236617017), retrieved log says `Total tests: 63`, `Passed: 63` |
| Full frontend CI | 36 passed across 10 specs | [Frontend E2E Tests job](https://github.com/awekisa/PredictionsProject/actions/runs/35569052700/job/106236616957), retrieved log says all specs passed |
| Local backend with disposable PostgreSQL | 63 passed, 0 failed, 0 skipped | Recorded local output and PR author report |
| Targeted account/connection browser checks | 12 passed across the final applicable runs | PR author report; do not add these to the full-suite count as distinct coverage |
| Build and changed-file lint | Passed | PR author report |
| Repository-wide lint | 7 errors and 1 warning in unchanged files | Disclosed in PR; not silently treated as a clean whole-repository lint run |

Historical CI was inspected on 2026-09-22; the downstream application was not rebuilt or redeployed for this documentation pass. CI success is not a claim that each check was required by branch protection at the historical merge.

## 6. Failure and autonomous correction

During local HTTP tests, a `PipeWriter.UnflushedBytes` exception caused failures. The API targeted .NET 8 while the existing test project targeted .NET 9. The execution record shows the agent changing `Microsoft.AspNetCore.TestHost` from `8.0.11` to `9.0.11`; a later run against disposable PostgreSQL passed all 63 tests. The final package version is visible in the [committed project file](https://github.com/awekisa/PredictionsProject/blob/be5db872a8bcc60c7af1bcc971d39bb9d04489cf/PredictionsAPI.Tests/PredictionsAPI.Tests.csproj).

This correction occurred inside the implementation pass. It is not evidence of a separate review → repair cycle or of retry-budget enforcement. See the [sanitized failure, correction, and success excerpts](execution-excerpts.md).

## 7. Final diff and handoff

[PR #32's complete diff](https://github.com/awekisa/PredictionsProject/pull/32/files) and criterion-by-criterion body are the handoff. Linear records the progression Backlog → In Progress → In Review → Done, and a comment links the PR and verification results. At the end of the implementation turn, the agent reported that independent review was next and that it had not merged or deployed.

No comment beginning `Loop review of COMMIT_SHA`, formal review, or loop verdict-label event was found on this PR at audit time. An independent review must therefore remain **unverified**.

## 8. Approval and merge evidence

GitHub records merge commit [`f541d6f745a2ef97e9a589bfa6b8f82a586bd2a2`](https://github.com/awekisa/PredictionsProject/commit/f541d6f745a2ef97e9a589bfa6b8f82a586bd2a2), merged by account `awekisa` at **2026-09-21 06:37:11 UTC**. The next local instruction asked the agent to continue; it verified that the PR had merged before starting the dependent task.

This proves a merge event under the owner's account. It does not prove a manual click, a recorded final approval, or an independent review of the exact head. No missing human action is fabricated. The [machine-readable public snapshot](public-evidence.json) preserves selected IDs, SHAs, URLs, and results.

## What this demonstration establishes

A real requirement was decomposed into contracts, an agent implemented one feature and corrected a concrete test failure, verification was attached to a public PR, and merge state was checked before dependent work. The record also shows why policy needs durable evidence: direct implementation authorization differed from the normal queue gate, and review/human-merge provenance is incomplete.

For a quick hands-on demonstration of this repository itself, run the [credential-free package verification](local-verification.md). A future end-to-end demo should retain explicit issue approval, the readiness transition, a separate current-head review verdict, any repair cycle, and the human's merge confirmation. That evidence gap is listed in [gaps](../gaps.md), not filled with a staged success.
