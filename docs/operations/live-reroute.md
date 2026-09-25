# Live Reroute

## Purpose

Use live reroute only to correct the workspace assignment of already-open,
supported native application windows.

Live reroute is independent of cold-start workspace profiles. It does not launch
missing applications, recreate a desktop session, or restore browser state.

The approved snapshot is browser-free. It must not be used to launch LibreWolf,
create missing browser windows, match browser windows, or move browser windows.

## Approved snapshot

The repository snapshot filename remains:

```text
sessions/sysadmin-managed-reroute-v1-ws1-ws6-no-stale-ws1-browser-2026-08-24.yaml
```

Bootstrap deploys that approved snapshot as the installed session:

```text
sysadmin-live-reroute
```

It contains exactly ten native rules:

| Workspace | Managed native rules |
|---|---|
| WS1 | Spotify |
| WS2 | Dedicated WS2 terminal |
| WS3 | Dedicated WS3 terminal |
| WS4 | Dedicated WS4 terminal |
| WS5 | Visual Studio Code |
| WS6 | Discord, Slack, Mattermost, Signal, GitKraken |

WS7 and all LibreWolf windows are excluded.

## Preconditions

- The intended native application window is already open.
- The window is one of the ten supported native rules.
- WS7 is treated as protected and outside managed reroute.
- You accept that a successful reroute may alter COSMIC's in-workspace tiling
  insertion order.
- You do not need live reroute to create or organize browser windows.

## Run

Use the preferred operator command:

```bash
ws-man reroute
```

The default timeout is 30 seconds. Override it for one operation when needed:

```bash
ws-man reroute --timeout 45
```

Enable COSMIC debug output:

```bash
ws-man reroute --debug
```

Preview the resolved operation without moving windows:

```bash
ws-man reroute --timeout 45 --debug --dry-run
```

`ws-man reroute` always uses the approved installed `sysadmin-live-reroute`
session. It does not accept a workspace, profile, category, baseline, or
arbitrary session argument.

The equivalent lower-level command is:

```bash
cosmic-wm restore \
  --timeout 30 \
  --debug \
  sysadmin-live-reroute
```

## Success criteria

- Matching native windows are routed to WS1 through WS6.
- No timeout occurs.
- No browser process is spawned.
- No browser window is matched or moved.
- WS7 windows remain outside the operation.
- The output ends with the successful organization message.

If an expected native application is missing, stop rather than relying on live
reroute to start it. Use cold start or an intentional manual launch for normal
managed startup, then use native reroute only if an already-open supported window
needs placement correction.

## Limitations

Live reroute does not restore tile placement, order, geometry, split ratios,
floating position, stack/tab layout, focus, browser windows, browser tabs, or
browser page identity.
