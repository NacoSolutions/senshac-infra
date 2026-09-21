# Verification Before Completion

Use this skill before reporting completion or handing work to Warren.

## Actions

- Run the repository gate: `bash scripts/check` (or `$WARREN_QUALITY_GATE` when set).
- Review `git diff --stat`, `git diff --check`, and `git status --short`.
- Confirm `.seeds/` and `.mulch/` state is preserved unless the task explicitly requests a tracker change.
- Commit the completed change with `git add <intended-files>` and `git commit`; Warren delivers the committed branch.
- Run the gate again after the commit, then verify `git status` and `git log -1 --oneline`.

## Acceptance

- The quality gate exits zero before and after the commit.
- The commit contains the intended documentation, skills, and configuration files only.
- The working tree contains the intended committed changes, and Warren can deliver the branch and open the PR.
