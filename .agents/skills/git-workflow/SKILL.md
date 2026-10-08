---
name: git-workflow
description: Keep focused Senshac infrastructure changes reviewable and committed.
---

# Git workflow

Use this workflow for each focused Senshac infrastructure change.

## Actions

1. Start with `git status --short --branch` and inspect the named files. Keep unrelated worktree state intact.
2. Make a focused Worktrunk branch and review `git diff --check`, `git diff --stat`, and the full intended diff.
3. Stage only the named files and commit with a concise imperative message.
4. Confirm the tracked worktree is clean and record the commit with `git log -1 --oneline`; use the repository's PR workflow for delivery.

## Acceptance checks

- `git diff --check` exits zero.
- The commit contains only the intended infrastructure, documentation, or configuration files.
- `git status --short` is clean after commit.
