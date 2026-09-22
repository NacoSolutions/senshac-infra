# Senshac Infrastructure

This focused repository owns Cloudflare account resource policy and operations
for Senshac, including Cloudflare, Podman, Caddy, Tailscale, and Warren
operations. It does not own Astro application code, Tina schema/content, or
the normal GitHub-to-Pages website deployment path.

## Agent Guidance

For focused autonomous changes, use [Bounded Warren Task](.agents/skills/bounded-warren-task/SKILL.md).
Use positive, specific instructions and state the desired outcome. Apply defense
in depth, gentle coding, direct execution, and token economy: inspect the
smallest relevant surface, preserve adjacent behavior, make the narrow change,
and run the bounded validation that proves it.

## Curated Skills

Use the skill that matches the task before editing:

| Skill | When to use |
| --- | --- |
| [Senshac Agent Principles](.agents/skills/senshac-agent-principles/SKILL.md) | Every focused change; it defines the six portable working principles. |
| [Warren Operations](.agents/skills/warren-operations/SKILL.md) | Warren configuration, worktrees, Seeds, or agent-operation changes. |
| [Cloudflare Operations](.agents/skills/cloudflare-operations/SKILL.md) | Cloudflare, R2, inventory, or infrastructure-operation work. |
| [Security Review](.agents/skills/security-review/SKILL.md) | Changes involving credentials, access, secrets, or security-sensitive operations. |
| [Verification Before Completion](.agents/skills/verification-before-completion/SKILL.md) | Before reporting completion, committing, or handing work to Warren. |

Run ./scripts/check before merging. ./scripts/inventory is read-only and
prints only resource names, status, and variable types. Never put Cloudflare,
R2, Tina, email, or SOPS private values in tracked files or command output.

Use one Worktrunk worktree per independently mergeable Seed. Canonical Seeds
and Terrarium tracking remains in NacoSolutions/senshac until a dedicated
cross-repository tracker migration changes ownership.

## Agent Workflow

- Run `sd prime` for Seeds context and `sd ready` to find unblocked work.
- Run `ml prime` before implementation; use `ml record <domain> --type <type>` for durable project learnings.
- Keep `.seeds/` and `.mulch/` changes focused and commit them with the work they describe.

## Portable rules and CLI skills

Load `.agents/rules/` for Caveman ultra, direct execution, positive phrasing,
defense in depth, gentle coding, token economy, and llm-shorthand. Load
`instruction-specificity.md` when authoring agent guidance. Use the local
`seeds-cli`, `mulch-cli`, `warren-operations`, and
`verification-before-completion` skills for tracker, expertise, Warren, and
completion work. Load role-specific skills for the implementation surface.
