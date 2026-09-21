# Senshac Infrastructure

This focused repository owns Cloudflare account resource policy and operations
for Senshac. It does not own Astro application code, Tina schema/content, or
the normal GitHub-to-Pages website deployment path.

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

## Warren Operations Agent Guidance

This repository guides Cloudflare, Podman, Caddy, Tailscale, and Warren operations. For focused autonomous changes, follow the [Bounded Warren Task skill](.agents/skills/bounded-warren-task/SKILL.md).

- Use positive phrasing and specific instructions; state the desired operational outcome.
- Apply defense in depth, preserve adjacent behavior, and make gentle, reversible edits.
- Execute directly with the smallest relevant inspection and bounded validation.
- Keep work within the named objective and files; use tokens economically.
