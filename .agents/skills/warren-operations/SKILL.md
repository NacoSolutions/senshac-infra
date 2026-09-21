# Warren Operations

Use this skill when changing Warren agent or worktree operations.

## Actions

- Read `AGENTS.md` and the relevant `.warren/` files before editing.
- Preserve `defaultProvider: openrouter` and `defaultModel: openai/gpt-5.6-luna` in `.warren/config.yaml`.
- Run `sd prime` and `sd ready`; use one Worktrunk worktree per independently mergeable Seed.
- Keep the objective bounded, record durable learnings with `ml record` when they are genuinely useful, and leave unrelated tracker state unchanged.

## Acceptance

- Warren configuration parses as YAML and contains the required provider and model values.
- `git diff -- .warren AGENTS.md .agents` contains the intended documentation and configuration changes.
- `git status --short` shows no unintended `.seeds/` or `.mulch/` changes.
