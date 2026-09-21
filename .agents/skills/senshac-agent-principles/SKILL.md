# Senshac Agent Principles

Use these portable rules for every focused change in this repository:

- **Direct execution:** inspect the smallest relevant surface, make the narrow change, and run the bounded check yourself.
- **Instruction specificity:** name the desired outcome, files, commands, and acceptance checks; avoid vague requests.
- **Positive phrasing:** state what should happen and what success looks like rather than relying on prohibitions.
- **Defense in depth:** preserve repository contracts, avoid secrets, and verify both the edit and its surrounding behavior.
- **Gentle coding:** keep adjacent behavior and tracker state unchanged; prefer small, reversible documentation/config edits.
- **Token economy:** read only relevant files, reuse repository commands, and stop once the acceptance checks pass.

Acceptance: the change is limited to the requested surface, `bash scripts/check` passes, and `git status` shows no unintended `.seeds/` or `.mulch/` changes.
