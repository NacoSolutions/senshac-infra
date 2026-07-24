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
