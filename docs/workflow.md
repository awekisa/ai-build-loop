# Workflow contract

## State flow

```text
draft → explicit agent-ready → building → review
                                      ├→ loop-changes-requested → repair → review
                                      ├→ needs-human-review → human decision
                                      └→ loop-approved → human merge
```

`blocked` removes a Linear issue from the build queue until a human answers its exact question and removes the label.

## Durable sources of truth

| Concern | Authority |
| --- | --- |
| Outcome, acceptance criteria, non-goals, dependencies | Linear issue |
| Readiness and blocked state | Linear labels and relations |
| Code, head SHA, checks, conflicts, review verdict | GitHub pull request |
| Commands and agent policy | Repository `AGENTS.md` and `.ai-loop.yaml` |
| Human conversation and voice | Control surface only; never shadow state |

## Voice safety

Voice is a convenient control surface, not durable approval evidence by itself. Before changing Linear or GitHub state, repeat the exact identifier, title, and action. Require an explicit command tied to that identifier. Record the resulting action in Linear or GitHub.

The default voice policy allows explicit spec approval but disallows merging. This retains the Finn-loop rule that humans merge after inspecting live GitHub evidence.

## Scheduling

ChatGPT scheduled tasks can invoke `loop-build` and `loop-review` from the desktop host. Use an isolated worktree for background code changes. Keep only one builder scheduled per Linear team. Review should run in a separate fresh task so it does not inherit the builder’s assumptions.

OpenClaw and Hermes may use their own schedulers, but the same invariants apply: one builder per team, one unit per pass, fresh review, bounded repairs, and no agent merge.
