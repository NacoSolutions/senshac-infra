# R2 Policy Import Runbook

This runbook is deliberately split into read-only discovery and mutation. The
current object-level S3 credentials do not grant bucket policy access.

## Required inputs

For discovery, put these values in the infra wrapper's untracked `.env.local`:

```dotenv
CLOUDFLARE_ACCOUNT_ID=<account id>
CLOUDFLARE_API_TOKEN=<R2 Admin Read only token>
```

The token must be scoped to `senshac-media-raw` and `senshac-media-prod` and
must include bucket configuration read access. Do not reuse the Tina object
credentials as the Cloudflare API token.

## Read-only discovery

Run from `senshac-infra/main`:

```bash
dx ./scripts/inventory
```

Capture the sanitized output in the seed evidence. Separately record, without
credentials or object contents:

- CORS rules for both buckets
- public custom-domain status for `media.senshac.com`
- lifecycle and retention rules
- cache policy and any cache headers observed from public media URLs
- bucket location and jurisdiction

Verify representative public objects from the web repository, including one
image, one font, and the current `la-trobada` media. Do not migrate objects.

## OpenTofu preparation

After discovery is reviewed, create a private state bucket separate from both
media buckets. Test state locking in a disposable prefix before importing any
production resource. The provider lock file must be committed, while backend
credentials remain injected through SOPS-decoded environment variables.

The import sequence is one policy surface at a time:

1. R2 bucket policy and CORS.
2. Public custom domain.
3. Lifecycle and cache policy.
4. Drift detection in CI.

Each import requires a reviewed plan. No `apply`, bucket replacement, object
copy, or deletion is authorized by this runbook.

## Mutation approval

The apply seed requires a separate Cloudflare token with `R2 Storage: Admin Read
& Write`, scoped to the two media buckets and the dedicated state bucket. The
token should be created only immediately before the approved import and
revoked or rotated after the migration window.
