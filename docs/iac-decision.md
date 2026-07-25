# Infrastructure-as-Code Decision

Status: accepted for the first migration slice, 2026-07-25.

## Decision

- Use OpenTofu from FloxHub as the IaC CLI.
- Use the Cloudflare provider with a checked-in version constraint and a
  committed provider lock file once initialization is performed.
- Store state in a dedicated private R2 bucket through the S3-compatible
  backend. State credentials are supplied at runtime through the wrapper's
  secret environment, never committed or placed in the state repository.
- Use OpenTofu's native state locking support for the selected S3 backend.
  A state lock must be confirmed in a disposable backend test before any
  production import.

This keeps the toolchain in the same Flox environment as the inventory command,
works with the existing R2 account, and avoids introducing a hosted SaaS state
service. The state bucket is separate from `senshac-media-raw` and
`senshac-media-prod`.

## Migration sequence

1. Create the private state bucket and credentials under a separate approved
   access seed.
2. Add the Cloudflare provider constraint and initialize OpenTofu in a
   disposable state prefix.
3. Verify state locking, encryption-at-rest policy, and CI read/write access.
4. Generate import candidates from the read-only inventory and review the plan.
5. Import one policy surface at a time; no apply is allowed without a reviewed
   plan and an explicit seed.

## Drift, access, and rollback

Drift detection runs `tofu plan -detailed-exitcode` on the protected CI path,
with exit code 2 reported for review. CI receives only the minimum Cloudflare
and state-backend credentials needed for the selected operation. Human imports
use the same provider and backend configuration from a local SOPS-decoded
environment.

Rollback is the prior reviewed state plus the provider's inverse change. State
versions remain retained by the R2 bucket policy. No state deletion, bucket
replacement, or broad account token is part of this decision.

## Explicit non-goals

This change does not create buckets, change Cloudflare settings, import
resources, or add credentials. Those actions require their own seeds and a
least-privilege infrastructure token.
