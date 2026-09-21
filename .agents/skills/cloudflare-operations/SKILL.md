# Cloudflare Operations

Use when documenting or operating Cloudflare resources, R2, or infrastructure inventory.

## Actions

- Read the relevant runbook under `docs/` before proposing an operation.
- Use `./scripts/inventory` only through the repository's credential wrapper (`dx ./scripts/inventory`) when credentials are available; treat it as read-only.
- Use short-lived, least-privilege credentials supplied by the operator; never place Cloudflare, R2, or SOPS values in tracked files or command output.
- Run `./scripts/check` after documentation or operations-contract changes.

## Acceptance

- Resource names/statuses/types are sufficient evidence; secret values are absent.
- No production mutation is performed by an inventory check.
- `bash scripts/check` exits zero.
