# AI build loop

Use the project skills `loop-spec`, `loop-build`, and `loop-review` for repository work that changes code, tests, build configuration, schemas, or deployable behavior.

## Routing

- A raw idea, bug report, refactor request, or ambiguous code change starts with `loop-spec`.
- Implementation starts only from a Linear issue carrying `agent-ready`; use `loop-build`.
- Every loop pull request receives a fresh-context `loop-review` after required checks settle and after every new head commit.
- Explanations, code reading, diagnostics without edits, and standalone snippets do not require the loop unless the user explicitly invokes it.

Linear is the source of truth for scope and approval. GitHub is the source of truth for code, CI, review evidence, and merge state. Do not accept side-channel scope changes during build or review; amend and reapprove the Linear issue instead.

## Human gates

- Only an explicit human action may apply `agent-ready`.
- Agents never merge, enable auto-merge, deploy, or change production state.
- A PR labeled `needs-human-review` has left automation until a human resolves the stated reason.
- For voice instructions, repeat the exact Linear issue or GitHub PR identifier and the consequential action before mutating external state. Never treat “yes,” “go ahead,” or similar context-free speech as approval.

## Repository setup

Read `.ai-loop.yaml` before loop work. It defines the Linear team, GitHub repository, labels, verification commands, retry budget, and voice policy. If absent, create it from `.ai-loop.example.yaml` and obtain confirmation for unresolved values.

Keep one issue per PR and one builder per Linear team. Use isolated Git worktrees for intentional parallel work. Stop after the configured repair limit and ask for the exact human decision needed.
