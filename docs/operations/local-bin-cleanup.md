# Local Bin Cleanup

## Purpose

`~/bin` is no longer the source of truth for workspace-manager implementation.
The repository owns active workspace scripts, profiles, sessions, desktop
assets, and documentation.

Active compatibility entrypoints remain in `~/bin` so existing commands and
desktop assets continue to work.

## Active entrypoints

| Path | Expected target |
|---|---|
| `~/bin/workspace-term` | `scripts/bin/workspace-term` |
| `~/bin/workspace-profile` | `scripts/bin/workspace-profile` |
| `~/bin/open-workspace-terminal` | `scripts/bin/open-workspace-terminal` |
| `~/bin/launch-workspace-profile` | `scripts/bin/launch-workspace-profile` |

These paths should be symlinks to the repository-managed scripts.

## Legacy archive

Historical and one-time tools were moved to:

```text
~/bin/backups/workspace-manager-cleanup-20260917-150404/
```

The archive includes `MANIFEST.txt` and a README. Archived scripts are retained
for audit and rollback only, and script execute permissions were removed to
prevent accidental use.

## Rules

- Do not restore or run an archived script just because its command name is
  familiar.
- Do not use archived `startSysadmin.sh`; use
  `~/.local/bin/start-sysadmin-cold`.
- Do not use archived `restore-sysadmin-complete`.
- Make future active workspace-manager changes in the repository first.
- Deploy active repository assets through the repository bootstrap process.
- Preserve `~/bin` only for compatibility entrypoints and unrelated personal
  utilities.

## Verification

```bash
for command in \
  workspace-term \
  workspace-profile \
  open-workspace-terminal \
  launch-workspace-profile
do
  printf '%s -> %s\n' \
    "$HOME/bin/$command" \
    "$(readlink -f "$HOME/bin/$command")"
done
```
