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
