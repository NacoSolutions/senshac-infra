# Warren Podman operations

Warren runs as two rootless Podman pods on the operator host:

- `warren-naco` — NacoSolutions GitHub App and `warren.naco.solutions`
- `warren-rona` — RogerNavelsaker GitHub App and `warren.naco.casa`

Each pod contains a Warren control plane, Caddy, and Tailscale sidecar. The
Warren app uses the Docker sibling-container provider backed by the host's
rootless Podman socket. The app and sibling agents must share the same
host-visible workspace path.

## Service management

The user-systemd units are generated from the validated Podman definitions and
live on the host under `/home/rona/.config/warren-stack/systemd/`. They are not
committed here because they contain host-specific paths and secret references.

```bash
systemctl --user status pod-warren-naco.service pod-warren-rona.service
systemctl --user restart pod-warren-naco.service
systemctl --user restart pod-warren-rona.service
```

User lingering must remain enabled:

```bash
loginctl show-user "$USER" -p Linger
```

## Health checks

Use the instance's operator token from its Warren data volume; never print or
commit the token.

```bash
curl -fsS https://warren.naco.solutions/healthz
curl -fsS https://warren.naco.casa/healthz
curl -fsS -H "Authorization: Bearer $WARREN_NACO_OPERATOR_TOKEN" \
  https://warren.naco.solutions/readyz
```

`/readyz` must report `docker_cli`, `db_reachable`, and `agents` as healthy.

## Agent image

The Senshac runner publishes the agent image to GHCR. Warren projects pin the
immutable digest in their `.warren/config.yaml`; do not switch production runs
to `latest` during incident recovery.

The current validated image is documented in `senshac-runner` and includes
Node 24, Pi, GitHub CLI, Git, and jq. Heavy Flox/Nix and Cloudflare gates remain
in the runner repository or GitHub Actions.

## Rollback

If an app replacement fails, stop the new app container and restore the prior
container definition without deleting the data volume. Preserve Caddy and
Tailscale sidecars. Confirm the hostname returns HTTP 200 and `/readyz` is
healthy before retrying the migration.
