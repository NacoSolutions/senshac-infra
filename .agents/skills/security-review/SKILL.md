# Security Review

Use this skill before merging changes that mention credentials, Cloudflare, R2, email, SOPS, or operational access.

## Actions

- Inspect the diff and tracked-file list with `git diff --check` and `git ls-files`.
- Confirm secret-bearing paths remain ignored and untracked: `.env*`, `.secrets.act`, decrypted secret files, keys, and certificates.
- Check documentation for secret values, appropriately scoped permissions, and commands that preserve production state.
- Use read-only, scoped, short-lived credentials and redact command output.

## Acceptance

- `bash scripts/check` exits zero.
- `git diff --check` exits zero.
- The diff contains public-safe documentation and configuration, with secret-bearing paths remaining untracked.
