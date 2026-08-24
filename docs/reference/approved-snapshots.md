# Approved Snapshots

## Approved

| Snapshot | Intended use | Scope |
|---|---|---|
| `sysadmin-managed-reroute-v1-ws1-ws6-no-stale-ws1-browser-2026-08-24` | Manual live reroute | 17 already-open managed windows, WS1–WS6 |

## Why it is approved

The validated run:

- Reused all 17 current windows.
- Matched all 17 windows.
- Returned successfully.
- Did not spawn generic LibreWolf.
- Did not time out.
- Excluded the WS7 protected LibreWolf and COSMIC Terminal entries.

## Not approved

Older snapshots are retained only outside this repository as historical
artifacts. They include WS7 entries, stale browser matchers, or unvalidated
routing definitions.

In particular, do not use a snapshot that contains a generic LibreWolf command
for a title matcher that is not currently open. It can create an `about:blank`
LibreWolf window and wait for the configured timeout.
