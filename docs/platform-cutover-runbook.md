# Cloudflare platform inventory and cutover runbook

Status: preparation only. This document is read-only and does not authorize a
Cloudflare mutation. Replace every `<PLACEHOLDER>` before running a command;
never replace a placeholder with a value in this repository.

The `senshac-web` repository owns the Astro application and its normal
GitHub-to-Cloudflare Pages deployment. `senshac-infra` owns Cloudflare account
policy, resource inventory, and the evidence and rollback procedure. Infra
must not take over the Pages build or duplicate Tina application code.

No `senshac-web` cutover specification was present in this repository's
context when this runbook was written. The web owner must reconcile its
project name, build command, output directory, and environment-variable names
with this checklist before approval.

## 1. Operator boundary and prerequisites

The inventory is credential-free in the repository: it contains no token,
account value, project value, domain value, or secret. A later authorized
operator supplies credentials only in the process environment or an untracked
wrapper `.env.local`. Use a short-lived, read-only token and do not print its
value.

Minimum discovery permissions (all read-only):

- Account: **Cloudflare Pages: Read** for `<ACCOUNT_ID>`.
- Account: **R2 Storage: Read** (including bucket configuration read) for
  `senshac-media-raw`, `senshac-media-prod`, and the separately named state
  bucket if it exists.
- Zone: **Zone: Read**, **DNS: Read**, and **Workers Routes: Read** for
  `<ZONE_ID>` / `<DOMAIN>`.
- If the API token cannot combine these scopes, use separate short-lived
  tokens and record which evidence each token produced. Never use Tina's S3
  object credentials for Cloudflare API calls.

The eventual mutation token is not needed for this runbook. An approved
operation will additionally require Cloudflare Pages edit/deploy permission,
R2 Storage Admin Read & Write scoped to the two media buckets and state bucket,
and the minimum DNS/Workers Routes edit permission for the planned hostname
switch. The web owner separately needs GitHub repository Actions/deployment
permission; that is not an infra credential.

## 2. Run the sanitized inventory

From the repository root, use the existing read-only wrapper:

```bash
set -a
. ./.env.local                 # untracked; contains no output or committed values
set +a
./scripts/inventory | tee /tmp/senshac-cloudflare-inventory.txt
```

`./scripts/inventory` only calls GET endpoints for Pages projects, R2 buckets,
Workers scripts, and Queues. It emits resource names/status or API error
messages, never token values or object contents. Review `/tmp/...` locally and
copy only a redacted evidence summary into the seed record. If a family is
inaccessible, stop and obtain the missing read permission; do not work around
it with an admin token.

For the cutover-specific evidence, run these additional GET-only checks. They
are intentionally explicit so the operator can save response headers and
sanitized JSON without relying on a local CLI version:

```bash
export CF_API="https://api.cloudflare.com/client/v4"
export CF_ACCOUNT="<ACCOUNT_ID>"
export CF_ZONE="<ZONE_ID>"
export CF_PROJECT="<PAGES_PROJECT_NAME>"
export CF_DOMAIN="<DOMAIN>"
export CF_TOKEN='<READ_ONLY_TOKEN>' # shell only; never commit or echo
cf_get() { curl --fail-with-body --silent --show-error \
  -H "Authorization: Bearer $CF_TOKEN" -H 'Content-Type: application/json' "$1"; }

cf_get "$CF_API/accounts/$CF_ACCOUNT/pages/projects" \
  | jq '{success,errors,result: [.result[] | {name,subdomain,domains,source,build_config,production_branch,created_on,latest_deployment}]}' \
  > /tmp/senshac-pages-projects.json
cf_get "$CF_API/accounts/$CF_ACCOUNT/pages/projects/$CF_PROJECT" \
  | jq '{success,errors,result: {name,subdomain,domains,source,build_config,production_branch,latest_deployment}}' \
  > /tmp/senshac-pages-project.json
cf_get "$CF_API/accounts/$CF_ACCOUNT/r2/buckets" \
  | jq '{success,errors,result: [.result[] | {name,creation_date,location}]}' \
  > /tmp/senshac-r2-buckets.json
cf_get "$CF_API/zones?name=$CF_DOMAIN&status=active" \
  | jq '{success,errors,result: [.result[] | {id,name,status,name_servers}]}' \
  > /tmp/senshac-zone.json
cf_get "$CF_API/zones/$CF_ZONE/dns_records?per_page=100" \
  | jq '{success,errors,result: [.result[] | {id,type,name,content,proxied,ttl}]}' \
  > /tmp/senshac-dns-records.json
cf_get "$CF_API/zones/$CF_ZONE/workers/routes" \
  | jq '{success,errors,result: [.result[] | {id,pattern,enabled,script}]}' \
  > /tmp/senshac-workers-routes.json
```

The `content` field can expose an address that is operationally sensitive;
redact it to `<ORIGIN_OR_TARGET>` before sharing evidence. Do not save the
`CF_TOKEN` export, raw API responses containing secret configuration, or
response bodies outside the operator's protected workspace.

## 3. Acceptance checks

### Pages ownership and build

Compare the Pages response with the approved `senshac-web` specification and
record pass/fail for each item:

- project name is `<PAGES_PROJECT_NAME>` in account `<ACCOUNT_ID>`;
- GitHub source is the `senshac-web` repository and the deployment integration
  is owned by the web team;
- production branch is `<PRODUCTION_BRANCH>`;
- framework/build command is `<BUILD_COMMAND>` and output directory is
  `<OUTPUT_DIRECTORY>`;
- production and preview domain names are exactly the approved names;
- the latest deployment commit is present in the web repository and has a
  successful status; and
- Pages environment-variable **names** are owned and set in `senshac-web`.

Never export Pages variable values. A read-only inventory cannot prove a value
is correct; the web owner must attest to the names and perform a deployment
smoke test from the web repository.

### R2 bindings and policy ownership

Confirm that the only expected buckets are `senshac-media-raw`,
`senshac-media-prod`, and (if already approved) a distinct private state bucket
`<STATE_BUCKET>`. Record bucket location and existence, but not objects or
credentials. For each media bucket, the infra owner must later attest to CORS,
custom-domain, lifecycle/retention, cache policy, and public/private status.

The web application consumes the approved public media binding/configuration;
infra owns bucket policy and Cloudflare configuration. Tina/media object
credentials remain in the web/media-runner scopes described in
`docs/secret-ownership.md`. Do not use them to inspect or change bucket policy.
No binding, policy, object copy, bucket creation, or deletion is permitted in
this preparation slice.

### TinaCMS secret ownership

`TinaCMS` editor credentials, media settings, contact delivery, Turnstile, and
Pages runtime configuration belong to `senshac-web`. Cloudflare account policy,
R2 policy, DNS/routes, and IaC backend credentials belong to `senshac-infra`.
Use this non-secret check in each repository:

```bash
git grep -lE 'TINA|S3_ACCESS_KEY_ID|S3_SECRET_ACCESS_KEY|CLOUDFLARE_API_TOKEN' -- ':!*.sops' || true
git ls-files | grep -E '(^|/)(\.env|.*\.plain\.env|.*\.dec\.env)' && exit 1 || true
```

Review names and ownership only. Never print a value, decrypt a file into Git,
or copy `senshac-web`'s `.env.local` into infra. Verify encrypted files without
printing plaintext with `sops --decrypt <FILE>.sops >/dev/null` when an approved
secret file exists.

### DNS and route switch prerequisites

Before any switch, obtain written approval containing the exact hostname(s),
current target, new Pages target, TTL/proxy choice, planned UTC window, and
owner/on-call. Confirm the zone is active, the record and any Workers route are
identified in the sanitized evidence, and the current site is healthy. Confirm
that Pages custom domains are already attached and TLS is valid. Do not change
DNS, routes, registrar nameservers, redirects, or cache rules as part of this
runbook.

The cutover operator must also have a tested web smoke check for `/`, one
representative page, Tina editor access (without recording its token), one
public image/font, and the contact path if applicable. Capture HTTP status,
redirect chain, certificate hostname, and deployment commit—not cookies,
headers containing credentials, or form contents.

## 4. Evidence and rollback

Store a reviewable evidence bundle outside Git or in the approved seed
attachment location. It must contain:

1. timestamp, operator, token scope (not token), account/zone/project names;
2. sanitized Pages, R2, zone, DNS, and route responses from the GET checks;
3. approved web commit, Pages deployment ID/status, and build settings;
4. current DNS/route target and the proposed target;
5. R2 policy ownership and the result of the secret-ownership checks; and
6. smoke-test results, approval, window, and the person authorized to revert.

Before mutation, preserve the current DNS record/route JSON, Pages project
settings, and the last known-good web commit. A rollback is the reviewed
inverse of the approved change: restore the prior DNS/route target, restore the
prior Pages deployment or web commit, and restore the prior reviewed policy
configuration. Re-run the smoke checks and record timestamps and status codes.
Do not delete state, buckets, objects, or Pages projects to roll back. If the
old target or evidence is unavailable, stop rather than guessing.

This preparation seed is complete only when the inventory is captured,
redacted, reconciled with the web owner, and the required mutation permissions
are separately approved. No Cloudflare mutation is implied by this document.
