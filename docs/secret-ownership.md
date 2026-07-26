# Focused Repository Secret Ownership

Each focused repository owns an encrypted secret file containing only the
credentials required by that repository's commands and CI jobs. The
meta-repository stores recipient and ownership policy, not a shared bundle of
application secrets.

## Repository scopes

| Repository | Allowed secret scope |
| --- | --- |
| `senshac-web` | Pages runtime, Tina editor, contact delivery, Turnstile, and public media configuration required by the web app |
| `senshac-infra` | Cloudflare account policy, R2 policy, DNS/zone operations, and IaC state backend |
| `senshac-runner` | CI image publication and runner verification only |
| `senshac-media-runner` | Media input/output storage and media processing publication only |
| `senshac-workspace` | No runtime credentials; registry and bootstrap metadata only |

The table is a deny-by-default boundary. A job must not decrypt another
repository's secret file merely because both repositories use the same account.
Split credentials by operation and bucket whenever Cloudflare permits it.

## SOPS layout

Encrypted files live in the focused repository that owns the contract, for
example `secrets/infra.env.sops` or `secrets/media-runner.env.sops`. They use
the repository's required age recipients plus the operator's GPG recipient.
The meta-repository may contain non-secret recipient policy and documentation,
but never plaintext values or an all-repositories secret file.

The SSH host-derived age recipient is for the approved host workflow. The CI
SSH-derived age recipient is for that repository's CI workflow only. The user
GPG recipient is for interactive recovery and editing. A recipient is added to
the smallest repository scope that needs it.

## Review checklist

Before adding or rotating a secret:

1. Name the exact command or workflow that needs it.
2. Confirm the owning focused repository.
3. Use the narrowest account, bucket, zone, or project permission.
4. Add only the required recipients to that repository's SOPS file.
5. Test decryptability without printing plaintext.
6. Run the repository's leak and plaintext-secret checks.
7. Record rotation and revocation responsibility without recording values.

Never copy the web `.env.local` into infra, runner, media, or workspace. Local
wrapper environment files remain untracked compatibility files; committed
secret material is encrypted SOPS data only.
