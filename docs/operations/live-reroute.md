# Live Reroute

## Purpose

Use live reroute only to correct the workspace assignment of already-open,
supported native application windows.

The approved snapshot is browser-free. It must not be used to launch LibreWolf
or recreate missing browser windows.

## Approved snapshot

The repository filename remains:

```text
sessions/sysadmin-managed-reroute-v1-ws1-ws6-no-stale-ws1-browser-2026-08-24.yaml
```

Its YAML name is:

```text
sysadmin-live-native-reroute
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

```bash
cosmic-wm restore \
  --timeout 30 \
  --debug \
  sysadmin-managed-reroute-v1-ws1-ws6-no-stale-ws1-browser-2026-08-24
```

## Success criteria

- Matching native windows are routed to WS1 through WS6.
- No timeout occurs.
- No browser process is spawned.
- WS7 windows remain outside the operation.
- The output ends with the successful organization message.

If an expected native application is missing, stop rather than relying on
live reroute to start it. Use cold start or an intentional manual launch for
normal managed startup, then use native reroute only if an already-open supported
window needs placement correction.

## Limitations

Live reroute does not restore tile placement, order, geometry, split ratios,
floating position, stack/tab layout, focus, browser windows, browser tabs, or
browser page identity.
