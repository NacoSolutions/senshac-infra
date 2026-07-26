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

## Secret file workflow

Secret files may be committed only after the repository's SOPS recipient
policy is reviewed. This project uses plain SOPS and does not depend on
`sops-nix`.

- Derive age recipients from the SSH host key and the CI SSH key. Keep the
  corresponding private keys outside Git and outside generated build output.
- Add the user's GPG public key as a SOPS PGP recipient for interactive edits
  from VS Code or the terminal.
- Keep separate recipients for host, CI, and user recovery. Removing one
  recipient must not make existing secrets undecryptable by the remaining
  authorized operators.
- Store encrypted files in the meta-repository or the focused repository that
  owns the secret contract. Store no plaintext `.env`, private key, token, or
  decrypted export.

Use `sops --age` for the age recipients and the user's GPG fingerprint as the
PGP recipient. Runtime jobs decrypt to an environment or a short-lived file,
run the command, and remove the plaintext immediately. CI must fail closed
when the required decrypting key is unavailable.

Before committing the first encrypted file, verify decryption without printing
the plaintext:

```bash
sops --decrypt path/to/secret.env.sops >/dev/null
```

The actual recipient list and key locations belong in the private operator
runbook, not in this public repository.
