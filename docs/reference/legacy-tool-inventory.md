# Legacy Tool Inventory

## Purpose

The repository is the source of truth for active workspace-manager scripts,
profiles, sessions, desktop assets, and documentation. Historical or one-time
workspace-manager tools formerly stored in `~/bin` were archived during the
2026-09-17 cleanup.

## Archive location

```text
~/bin/backups/workspace-manager-cleanup-20260917-150404/
```

The archive retains `MANIFEST.txt`, its README, and non-executable historical
files for audit and rollback only.

## Active replacements

| Historical purpose | Current canonical replacement |
|---|---|
| Start all sysadmin workspaces | `~/.local/bin/start-sysadmin-cold` |
| Choose a workspace profile | `~/bin/launch-workspace-profile --prompt` |
| Run the sysadmin selection non-interactively | `workspace-profile --profile sysadmin` |
| Open dedicated WS2–WS4 terminals | `~/bin/open-workspace-terminal <2|3|4>` |
| Inspect workspace/window state | `cosmic-wm status` |
| Correct supported native window placement | Approved native live reroute |
| Historical browser repair helpers | Cold-start profile ownership and manual identified-window handling |

## Archived categories

The dated archive includes:

- One-time workspace creation, conversion, and migration tools
- Snapshot builders and legacy full-restore helpers
- Browser profile, browser-window, and shared-session repair tools
- Patch scripts for `startSysadmin.sh`, workspace profiles, WS4, WS6, and
  infrastructure routing
- Obsolete launchers such as `startSysadmin.sh`, `startLibrewolfWorkspaces.sh`,
  `launch-ws6`, and `restore-sysadmin-complete`
- Historical README and backup artifacts

See `MANIFEST.txt` in the archive for the complete historical filename list.

## Do not reactivate by default

Do not restore or execute archived tools simply because an old command name is
recognized. In particular:

- Do not run archived `startSysadmin.sh`; it was replaced by the canonical
  `start-sysadmin-cold` path.
- Do not run archived `restore-sysadmin-complete`.
- Do not use historical browser repair helpers to add LibreWolf behavior back
  into native live reroute.
- Do not use broad `pkill librewolf` cleanup.

If rollback is necessary, inspect the archived script, identify the exact
behavior required, and reproduce the required change in a reviewed,
repository-tracked implementation rather than reinstating a broad legacy tool.
