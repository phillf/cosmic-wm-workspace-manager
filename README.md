# CT COSMIC Workspace Manager

Configuration, launch assets, scripts, and operating documentation for the CT
COSMIC workstation workspace arrangement.

## Scope

The managed operational workspace range is WS1 through WS6. WS7 is a protected
assistant/control workspace and is deliberately excluded from the approved
reroute snapshot.

This repository supports two different workflows:

1. **Cold start:** launch the six canonical `sysadmin-wsN` profiles serially.
2. **Live reroute:** return already-open managed windows to their resident
   workspaces with the approved 17-window snapshot.

These workflows are not interchangeable.

## Quick start

### Cold start

Run the canonical launcher:

```bash
~/.local/bin/start-sysadmin-cold
```

It launches the following profiles serially:

```text
sysadmin-ws1
sysadmin-ws2
sysadmin-ws3
sysadmin-ws4
sysadmin-ws5
sysadmin-ws6
```

### Live reroute

Use only when all 17 managed windows are already open:

```bash
cosmic-wm restore \
  --timeout 30 \
  --debug \
  sysadmin-managed-reroute-v1-ws1-ws6-no-stale-ws1-browser-2026-08-24
```

Do not use the reroute snapshot as a cold-start mechanism.

## Confirmed behavior

| Capability | Result |
|---|---|
| Reuse currently open managed windows | Supported |
| Route managed windows to WS1–WS6 | Supported |
| Keep WS7 out of the approved reroute input | Supported |
| Launch the serial cold-start profiles | Supported |
| Restore in-workspace tile order | Not supported |
| Restore sizes, split ratios, or geometry | Not supported |
| Restore stacks/tab groups | Not supported |
| Reliably recreate browser windows by saved title | Not supported |

## Repository structure

```text
profiles/  Canonical WS1–WS6 cold-start profiles
sessions/  Approved reroute-only session snapshot
scripts/   Launchers, desktop entries, and retained supporting scripts
docs/      Architecture, operating procedures, reference, and upstream request
```

## Read next

- [Workspace model](docs/architecture/workspace-model.md)
- [Restore boundaries](docs/architecture/restore-boundaries.md)
- [Cold-start procedure](docs/operations/cold-start.md)
- [Live-reroute procedure](docs/operations/live-reroute.md)
- [Known limitations](docs/reference/known-limitations.md)
- [Upstream feature request](docs/upstream/cosmic-layout-restore-feature-request.md)

## Bootstrap deployment

The repository is the source of truth. Deploy its active assets as user-local
symlinks with:

```bash
./scripts/bootstrap.sh --dry-run --force
./scripts/bootstrap.sh --force
```

The bootstrap links WS1–WS6 profiles, the approved live-reroute alias, active
launch scripts, and desktop entries. It backs up conflicting files before
replacing them, does not change autostart unless explicitly requested, and
quarantines two known unsafe legacy snapshots.

After deployment:

```bash
start-sysadmin-cold
cosmic-wm restore --timeout 30 --debug sysadmin-live-reroute
```

## Safety

Do not commit credentials, browser profiles, cookies, session stores, private
URLs, or local runtime state. Review all changes before committing.
