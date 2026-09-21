# Warren Operations

Use when changing Warren agent or worktree operations.

## Actions

- Read `AGENTS.md` and the relevant `.warren/` files before editing.
- Confirm `.warren/config.yaml` retains `defaultProvider: openrouter` and `defaultModel: openai/gpt-5.6-luna`.
- Run `sd prime` and `sd ready`; use one Worktrunk worktree per independently mergeable Seed.
- Keep the objective bounded, record durable learnings with `ml record` when they are genuinely useful, and do not edit tracker state for unrelated work.

## Acceptance

- Warren configuration parses as YAML and contains the required provider/model values.
- `git diff -- .warren AGENTS.md .agents` contains only the intended documentation/config changes.
- `git status --short` shows no unintended `.seeds/` or `.mulch/` changes.
