# Recovery

## Choose the correct operation

| Situation | Safe response |
|---|---|
| Managed profile applications need to be started | Run the canonical cold start |
| Already-open supported native app is on the wrong workspace | Run native-only live reroute |
| Browser window is missing | Use its owning cold-start profile or intentionally launch it |
| Browser window is misplaced | Move the identified window manually |
| Native app is not covered by the ten rules | Move it manually or add a separately reviewed future rule |
| Tile geometry or window order is wrong | Arrange manually with normal COSMIC tiling controls |
| WS7 window moved or affected | Correct it manually; do not add WS7 to managed reroute |

## Incorrect native workspace assignment

First inspect the current state:

```bash
cosmic-wm status
```

If the window is a supported native application and is already open, run:

```bash
cosmic-wm restore \
  --timeout 30 \
  --debug \
  sysadmin-managed-reroute-v1-ws1-ws6-no-stale-ws1-browser-2026-08-24
```

Then inspect `cosmic-wm status` again. Do not expect the reroute to restore the
previous tile layout.

## Missing or misplaced browser window

LibreWolf is outside live reroute. Do not add browser matchers or generic
browser launch commands to the approved native snapshot.

If a managed browser window is missing, use the normal cold-start workflow or
intentionally open the specific required page. If a browser window is simply on
the wrong workspace, move that identified window manually.

Never run:

```bash
pkill librewolf
```

It can terminate unrelated shared-session browser work, including protected WS7
assistant/control activity.

## Unwanted browser window

Close only the confirmed unwanted window through the desktop environment. Do
not repeatedly rerun a prior browser-aware snapshot and do not perform broad
browser process termination. See
[Browser duplicates](../troubleshooting/browser-duplicates.md).

## Incorrect in-workspace placement

The current session schema cannot repair tile geometry or ordering. Arrange
windows manually after routing. Repeating restore routes windows again; it does
not reconstruct positions, sizes, or splits.

## Obsolete legacy tools

Do not run historical scripts archived under:

```text
~/bin/backups/workspace-manager-cleanup-20260917-150404/
```

They are retained only for audit or rollback and have had executable permission
removed. In particular, do not use the archived `startSysadmin.sh` or
`restore-sysadmin-complete`.
