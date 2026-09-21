# Verification Before Completion

Use before reporting completion or handing work to Warren.

## Actions

- Run the repository gate: `bash scripts/check` (or `$WARREN_QUALITY_GATE` when set).
- Review `git diff --stat`, `git diff --check`, and `git status --short`.
- Confirm `.seeds/` and `.mulch/` state is preserved unless explicitly requested.
- Commit the completed change with `git add <intended-files>` and `git commit`; do not push.
- Run the gate again after the commit, then verify `git status` and `git log -1 --oneline`.

## Acceptance

- The quality gate exits zero before and after the commit.
- The commit contains the intended documentation/skills/config files only.
- No staged or unstaged unintended changes remain; Warren can deliver the branch and open the PR.
