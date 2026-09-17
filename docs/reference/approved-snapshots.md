# Approved Snapshots

## Approved

| Snapshot file | YAML name | Intended use | Scope |
|---|---|---|---|
| `sysadmin-managed-reroute-v1-ws1-ws6-no-stale-ws1-browser-2026-08-24.yaml` | `sysadmin-live-native-reroute` | Manual live reroute | Ten already-open native application windows in WS1–WS6 |

## Why it is approved

The current approved definition:

- Routes Spotify to WS1
- Routes dedicated terminals to WS2, WS3, and WS4
- Routes Visual Studio Code to WS5
- Routes Discord, Slack, Mattermost, Signal, and GitKraken to WS6
- Excludes WS7 assistant/control activity
- Contains no LibreWolf matcher or command
- Cannot launch a generic browser window through a failed browser title match

## Not approved

Older browser-aware snapshots are historical artifacts only. Do not use them as
live reroute input because their browser title matching can fail and may launch
an unwanted generic LibreWolf window.

Do not use a live reroute snapshot as a general cold-start replacement. Use
the canonical cold-start profiles when applications—including managed browser
windows—need to be launched.
