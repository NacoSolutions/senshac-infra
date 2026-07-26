# Senshac Infrastructure

Cloudflare infrastructure contracts and operations for Senshac.

The web repository remains the source of the Pages application artifact. This
repository will own account-level policy, infrastructure-as-code, resource
inventory, and rollback/runbook evidence once individual resources are
migrated through dedicated seeds.

## Read-only Inventory

With an infra-scoped token in the wrapper-local .env.local:

    dx ./scripts/inventory

The command intentionally omits secret values and reports inaccessible resource
families as errors. It makes no Cloudflare changes.

## R2 Access Tiers

The existing `S3_ACCESS_KEY_ID` and `S3_SECRET_ACCESS_KEY` are object-level
credentials used by Tina/media tooling. They are sufficient for object reads
and writes, but not for bucket CORS, custom-domain, lifecycle, or cache policy.

The R2 policy migration requires a separate Cloudflare API token with
`R2 Storage: Admin Read only`, scoped to `senshac-media-raw` and
`senshac-media-prod`. The later OpenTofu apply requires a separately approved
`Admin Read & Write` token. See `docs/r2-import-runbook.md`.
