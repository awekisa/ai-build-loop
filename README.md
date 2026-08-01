# AI Build Loop

A portable, human-gated coding loop for ChatGPT/Codex, OpenClaw, and Hermes Agent, adapted from [Finn-loop](https://github.com/finna/Finn-loop).

```text
idea → loop-spec → Linear approval → loop-build → GitHub PR → loop-review → human merge
```

The package contains three AgentSkills-compatible workflows:

- `loop-spec` researches the repository, interviews you, and creates a precise Linear issue.
- `loop-build` claims one approved issue, implements only its contract, verifies it, and opens a PR.
- `loop-review` independently checks one PR against the issue, current head, mergeability, and required CI.

## Why this works with voice

[ChatGPT Voice](https://learn.chatgpt.com/docs/features/voice) and [Remote](https://learn.chatgpt.com/docs/remote-connections) can start and steer Codex tasks on the connected host. The loop keeps voice interactions short: ask to spec an idea, approve a filed issue by exact identifier, start one build pass, or request status. Consequential actions require the identifier to be repeated. Agents never merge or deploy.

Example voice commands:

- “Use loop spec for this idea.”
- “Approve spec POK-123.”
- “Start one build-loop pass.”
- “Review the next loop pull request.”
- “What is my next human action?”

## Install in a project

Run:

```bash
./scripts/install-loop.sh codex /absolute/path/to/project
```

Use `openclaw` instead of `codex` for an OpenClaw workspace. Both platforms discover project skills from `.agents/skills`; see [OpenClaw skills](https://docs.openclaw.ai/skills). For Hermes, pass the Hermes home directory; see [Hermes skill installation](https://github.com/NousResearch/hermes-agent/blob/main/website/docs/guides/work-with-skills.md):

```bash
./scripts/install-loop.sh hermes /absolute/path/to/.hermes
```

The installer does not overwrite existing skill folders, `AGENTS.md`, or `.ai-loop.yaml`. Resolve any reported conflict explicitly. Start a new agent session after installation so the skill index refreshes.

Then:

1. Fill in `.ai-loop.yaml`, especially the Linear team, GitHub `owner/repository`, and project commands.
2. Connect the Linear app/connector on the agent surface.
3. Authenticate `gh` with write access to the repository, or provide an equivalent GitHub connector.
4. Create the Linear labels `agent-ready` and `blocked`.
5. Create the GitHub labels `loop-approved`, `loop-changes-requested`, and `needs-human-review`.
6. Configure at least one required GitHub status check. Without required CI, review escalates to `needs-human-review`.

Linear’s GitHub integration is recommended so PR and merge events update issues automatically.

## Daily rhythm

1. Invoke `loop-spec` while you are present. Review the filed issue, then explicitly approve its identifier.
2. Run one `loop-build` pass. A scheduled ChatGPT task may repeat this skill, but only one builder may operate per Linear team.
3. Run `loop-review` in a fresh task or fresh-context agent after CI settles.
4. Merge only after you personally confirm the reviewed SHA, green required checks, clean merge state, and `loop-approved` label.

See [docs/workflow.md](docs/workflow.md) for state transitions and operating boundaries.
