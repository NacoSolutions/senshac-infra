# Senshac Agent Principles

Apply these six principles to every focused change in this repository:

- **Direct execution:** Inspect the smallest relevant surface, make the narrow change, and run the bounded check yourself.
- **Instruction specificity:** Name the desired outcome, files, commands, and acceptance checks so each action is clear.
- **Positive phrasing:** State the desired action and the outcome that demonstrates success.
- **Defense in depth:** Preserve repository contracts, protect sensitive values, and verify both the edit and its surrounding behavior.
- **Gentle coding:** Keep adjacent behavior and tracker state unchanged; prefer small, reversible documentation and configuration edits.
- **Token economy:** Read relevant files, reuse repository commands, and stop when the acceptance checks pass.

## Acceptance

- The change stays within the requested guidance or configuration surface.
- `bash scripts/check` exits zero.
- `git status --short` shows no unintended `.seeds/` or `.mulch/` changes.
