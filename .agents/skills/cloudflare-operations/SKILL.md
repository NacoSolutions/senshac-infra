# Cloudflare Operations

Use this skill when documenting or operating Cloudflare resources, R2, or infrastructure inventory.

## Actions

- Read the relevant runbook under `docs/` before proposing an operation.
- Run `./scripts/inventory` through the repository's credential wrapper, such as `dx ./scripts/inventory`, when credentials are available; treat the command as read-only.
- Use short-lived, least-privilege credentials supplied by the operator, and keep Cloudflare, R2, and SOPS values out of tracked files and command output.
- Run `./scripts/check` after documentation or operations-contract changes.

## Acceptance

- Resource names, statuses, and types provide sufficient evidence while secret values remain absent.
- Inventory validation leaves production resources unchanged.
- `bash scripts/check` exits zero.
