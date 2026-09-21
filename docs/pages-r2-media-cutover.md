# Pages, R2, and media cutover validation

This is the validation contract for `senshac-infra` tracker
`senshac-workspace-83d8`. It records what the infrastructure owner must prove
without moving the Pages build, Astro application, Tina configuration, or media
objects into this repository.

The operator keeps raw API responses and deployment logs outside Git. A
redacted evidence directory can be checked locally with:

```bash
bash scripts/validate-cutover-evidence /path/to/redacted-evidence
```

The checker is offline. It requires `pages.json`, `r2.json`, `dns.json`,
`smoke.tsv`, and `rollback.md`; it rejects secret-like fields. The evidence
bundle is an attachment or protected operator artifact, not a tracked
configuration file.

## Ownership and secret boundary

| Surface | Owner | Validation evidence |
| --- | --- | --- |
| Pages project, GitHub integration, build settings, environment-variable names | `senshac-web` | project name, source, production branch, build command, output directory, and successful deployment commit |
| R2 bucket policy, CORS, custom domain, lifecycle, cache policy, DNS and Workers routes | `senshac-infra` | sanitized GET responses and approved change record |
| Astro routes, `_headers`, `_redirects`, Tina, contact delivery, Turnstile, and runtime values | `senshac-web` | web-repository preview/production smoke evidence |
| Object upload/processing credentials | media runner/web scopes | secret ownership review; never a Cloudflare API token |

No object-level S3 credential is valid for Cloudflare account operations. No
Pages, R2, DNS, or IaC credential is copied into the web or media-runner
scope. Values must remain in the operator's untracked wrapper or approved
SOPS-encrypted runtime input. Evidence may include names, statuses, IDs, and
variable names, but never token values, cookies, object contents, or plaintext
secret files.

## Pre-cutover acceptance

The operator records pass/fail and the evidence timestamp for every item:

### Pages and builds

- The approved Pages project belongs to the expected account and is sourced
  from `senshac-web`.
- The production branch, framework/build command, output directory, and
  deployment integration match the web-owner specification.
- Production and preview hostnames are attached, TLS covers each hostname,
  and the latest production deployment has a successful status and approved
  web commit.
- The web owner validates a preview deployment from the same commit or a
  deliberately documented preview commit. Production validation is performed
  only after preview passes.
- Pages variable **names** are reviewed in the web repository. Values are
  supplied by the Pages runtime and are not exported into this repository.

### R2 and media delivery

- Only the approved raw, processed/public, and separately named private state
  buckets are present. Bucket names, location, and status are recorded; object
  listings are not copied into evidence.
- Raw media is private and the public media surface is served only through the
  approved custom domain. CORS allows only the approved web origins and
  methods; it does not allow credentialed wildcard access.
- Lifecycle, retention, cache-control, and custom-domain settings match the
  approved policy. A representative image, font, and current article media
  are fetched through the public hostname without exposing storage credentials.
- Cache headers and content types are recorded for representative media. A
  cache purge or policy change is approved separately from a DNS switch.

### DNS, headers, and redirects

- The active zone, exact records, proxy/TLS mode, and any Workers route are
  identified in sanitized evidence. The current target and proposed Pages
  target are recorded before mutation.
- The web owner validates `_headers` for security headers and media caching,
  and `_redirects` for canonical-host and legacy-path behavior in both preview
  and production. Infra records the result; it does not duplicate those files.
- No wildcard, catch-all, or Workers route overlaps the approved Pages
  hostname unless explicitly reviewed. Redirects do not leak query-string
  secrets or create an open redirect.

## Two-stage smoke test

Run the same checks against preview first and production second. Record only
status, redirect locations after redaction, certificate hostname, cache
headers, and deployment commit. Do not record cookies, authorization headers,
form contents, or full response bodies.

| Check | Expected result |
| --- | --- |
| `/` and one representative page | 2xx, canonical hostname, approved commit |
| legacy URL and HTTP-to-HTTPS | reviewed 3xx chain, no loop |
| one public image and one font | 2xx, expected content type, approved cache policy |
| an intentionally missing media object | 404/410, no private storage error |
| Tina editor access (web owner only) | authenticated smoke succeeds; token is not captured |
| contact path (if enabled) | approved non-production/production test succeeds without storing contents |
| certificate and security headers | hostname matches; HSTS/CSP/frame/referrer policy match web spec |

Production is eligible for DNS/routing mutation only when preview has passed,
Pages custom domains are healthy, the current site is healthy, and written
approval names the hostname, target, UTC window, on-call, and revert owner.

## Rollback evidence

Before mutation, preserve outside Git:

1. the current DNS and Workers-route responses;
2. Pages project settings and the last known-good web commit/deployment;
3. the reviewed R2 policy, CORS, lifecycle, and cache configuration; and
4. the approval and smoke-test results.

Rollback is the reviewed inverse: restore the prior DNS/route target, restore
the prior Pages deployment or web commit, and restore the prior policy only if
it was changed in the window. Re-run the preview/production smoke checks and
record UTC timestamps and status codes. Do not delete buckets, objects, state,
or Pages projects as a rollback action. If the prior target or evidence is
missing, stop and escalate rather than guessing.

The commit containing this contract must include tracker ID
`senshac-workspace-83d8`; the PR description should link the same ID and list
which evidence items were validated.
