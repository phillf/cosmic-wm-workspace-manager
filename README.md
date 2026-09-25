# CT COSMIC Workspace Manager

Repository-managed configuration, launch assets, and operating documentation for
the CT COSMIC workstation workspace arrangement.

## Scope

WS1 through WS6 are the managed operational workspace range. WS7 is a protected
assistant/control workspace and remains outside managed cold-start and live-reroute
operations.

The repository supports two separate workflows:

| Workflow | Purpose | Browser behavior |
|---|---|---|
| Cold start | Start the normal WS1–WS6 managed workspace set serially | Launches profile-defined LibreWolf windows |
| Native live reroute | Correct placement of already-open supported native windows | Browser-free; must not launch, match, or move LibreWolf |

These workflows are not interchangeable.

## Quick start

### Start the managed workspace set

```bash
~/.local/bin/start-sysadmin-cold
```

This starts `sysadmin-ws1` through `sysadmin-ws6` serially. Use it after a
controlled login or when intended profile-defined applications, including managed
browser windows, need to be launched.

### Correct an already-open native window

```bash
cosmic-wm restore \
  --timeout 30 \
  --debug \
  sysadmin-managed-reroute-v1-ws1-ws6-no-stale-ws1-browser-2026-08-24
```

The current approved YAML is named `sysadmin-live-native-reroute` and contains
exactly ten native rules:

- WS1: Spotify
- WS2–WS4: dedicated workspace terminals
- WS5: Visual Studio Code
- WS6: Discord, Slack, Mattermost, Signal, and GitKraken

It excludes all browser windows and WS7.

### Refresh one workspace profile

```bash
ws-man sysadmin 3
```

This re-synchronizes the existing `sysadmin-ws3` profile with the default
180-second application/window matching timeout.

Preview a refresh without launching applications or moving windows:

```bash
ws-man sysadmin 3 --dry-run
```

## Supported behavior

| Capability | Result |
|---|---|
| Start WS1–WS6 cold-start profiles serially | Supported |
| Launch profile-defined LibreWolf windows during cold start | Supported |
| Refresh one existing sysadmin profile with `ws-man` | Supported |
| Route the ten supported native rules to WS1–WS6 | Supported |
| Keep WS7 outside the approved native reroute input | Supported |
| Use native reroute to create missing browser windows | Not supported |
| Restore browser tabs, page identity, or browser placement | Not supported |
| Restore in-workspace tile order | Not supported |
| Restore sizes, split ratios, or geometry | Not supported |
| Restore stacks or tab groups | Not supported |

## Repository structure

```text
cosmic-compose.yaml  Declarative COSMIC Compose category metadata
profiles/            Canonical WS1–WS6 cold-start profile definitions
sessions/            Approved native-only live-reroute snapshot
scripts/             Launchers, desktop assets, autostart source, and bootstrap tooling
docs/                Architecture, operations, troubleshooting, and references
```

## Read next

- [Workspace model](docs/architecture/workspace-model.md)
- [COSMIC Compose](docs/architecture/cosmic-compose.md)
- [Launch ownership](docs/architecture/launch-ownership.md)
- [Browser boundaries](docs/architecture/browser-boundaries.md)
- [Cold-start procedure](docs/operations/cold-start.md)
- [Live-reroute procedure](docs/operations/live-reroute.md)
- [Recovery procedure](docs/operations/recovery.md)
- [Canonical commands](docs/reference/canonical-commands.md)
- [Expected workspace windows](docs/reference/expected-workspace-windows.md)
- [Legacy tool inventory](docs/reference/legacy-tool-inventory.md)

## Deployment

The repository is the source of truth. The bootstrap deploys repository-managed
assets as user-local links after reviewing its planned changes:

```bash
./scripts/bootstrap.sh --dry-run --force
./scripts/bootstrap.sh --force
```

Use `--install-autostart` only when intentionally deploying the tracked
graphical-login autostart entry.

The installed profile chooser is expected to resolve as:

```text
~/.local/share/applications/ct-workspace-profile.desktop
  -> scripts/desktop/ct-workspace-profile.desktop
  -> ~/bin/launch-workspace-profile
  -> scripts/bin/launch-workspace-profile
```

Selecting `sysadmin` in that chooser invokes `~/.local/bin/start-sysadmin-cold`.

After running `./scripts/bootstrap.sh --force`, the repository also installs the
managed command path:

```text
~/bin/ws-man
  -> scripts/bin/ws-man
```

## Safety

- Do not use live reroute to start missing applications or browser windows.
- Do not add LibreWolf matchers or generic browser commands to the native
  reroute snapshot.
- Do not use `pkill librewolf` for selective browser cleanup.
- Do not commit credentials, browser profiles, cookies, session stores, private
  URLs, or local runtime state.
- Review every deployment and Git diff before applying it.

## `ws-man` command library

```bash
# Re-sync one existing sysadmin workspace.
ws-man sysadmin 1
ws-man sysadmin 6

# The default timeout is 180 seconds; override it when needed.
ws-man sysadmin 3 --timeout 45
ws-man sysadmin 6 --timeout 300

# Preview a command without launching applications or moving windows.
ws-man sysadmin 4 --dry-run

# Show current COSMIC application-to-workspace assignments.
ws-man status
```

`ws-man` currently supports full-profile synchronization and status only. Managed
window cleanup and category-scoped synchronization will be added separately after
their manifests and scoped profiles are repository-owned, reviewed, and
bootstrap-managed.

## COSMIC Compose

[COSMIC Compose](docs/architecture/cosmic-compose.md) is the repository's
declarative category and workspace-membership model. Its initial metadata
inventory is in [`cosmic-compose.yaml`](cosmic-compose.yaml).

The initial category taxonomy is:

- `terminals`
- `browsers`
- `communications`
- `git`
- `media`

COSMIC Compose currently documents WS3 application membership and provides
read-only validation and planning:

```bash
scripts/bin/cosmic-compose validate
scripts/bin/cosmic-compose plan sysadmin 3
scripts/bin/cosmic-compose plan sysadmin 3 terminals
scripts/bin/cosmic-compose plan sysadmin 3 browsers
scripts/bin/cosmic-compose plan sysadmin 3 media
scripts/bin/cosmic-compose profile sysadmin 3 terminals
scripts/bin/cosmic-compose profile sysadmin 3 browsers
```

The tool validates the manifest and any explicitly declared scoped cold-start
profiles, then prints declared membership only. Scoped profiles are verified as
complete category-specific subsets of their full workspace profile; they are not
rendered or deployed by this command. It does not modify bootstrap behavior,
change `ws-man`, alter autostart, modify COSMIC profile deployment, or launch or
move windows.

`cosmic-compose profile` resolves a declared scoped profile path only. It does
not install that profile, invoke `cosmic-wm`, or enable category dispatch in
`ws-man`.

WS3 currently has reviewed scoped cold-start definitions for `terminals` and
`browsers`. Their presence does not yet enable
`ws-man sysadmin 3 <category>`; category dispatch remains a separate
bootstrap-managed change.

Future category-scoped synchronization will use explicit, reviewed cold-start
profiles and will preserve the browser-free native live-reroute boundary.
