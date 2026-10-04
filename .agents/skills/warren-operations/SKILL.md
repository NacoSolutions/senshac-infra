# Warren Operations

Use this skill when changing Warren agent or worktree operations.

## Actions

- Read `AGENTS.md` and the relevant `.warren/` files before editing.
- Keep `agentImage`, `defaultProvider`, and `defaultModel` out of `.warren/config.yaml`; set image on the Warren instance and provider/model in agent definitions.
- Run `sd prime` and `sd ready`; use one Worktrunk worktree per independently mergeable Seed.
- Keep the objective bounded, record durable learnings with `ml record` when they are genuinely useful, and leave unrelated tracker state unchanged.

## Acceptance

- Warren configuration parses as YAML and contains the required provider and model values.
- `git diff -- .warren AGENTS.md .agents` contains the intended documentation and configuration changes.
- `git status --short` shows no unintended `.seeds/` or `.mulch/` changes.
