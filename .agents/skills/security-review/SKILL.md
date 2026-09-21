# Security Review

Use before merging changes that mention credentials, Cloudflare, R2, email, SOPS, or operational access.

## Actions

- Inspect the diff and tracked-file list: `git diff --check` and `git ls-files`.
- Confirm secret-bearing paths remain ignored and untracked: `.env*`, `.secrets.act`, decrypted secret files, keys, and certificates.
- Check documentation for secret values, overly broad permissions, and commands that could mutate production.
- Prefer read-only, scoped, short-lived credentials and redact command output.

## Acceptance

- `bash scripts/check` passes.
- `git diff --check` passes.
- No private values or new secret-bearing tracked files appear in the diff.
