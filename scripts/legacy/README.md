# Legacy Scripts

These scripts are retained as historical implementation references. They are not
part of the active deployment path and must not be run without review.

They were moved here because they mutate live files, target the former aggregate
`sysadmin.yaml` profile model, reference obsolete snapshots, or implement
one-time migration/patch actions.

## Active replacements

- Cold start: `../local-bin/start-sysadmin-cold`
- Workspace terminal launcher: `../bin/open-workspace-terminal`
- Workspace profile chooser: `../bin/launch-workspace-profile`
- Repository deployment: `../bootstrap.sh`
- Active profiles: `../../profiles/`
- Approved live reroute snapshot: `../../sessions/`

## Notable obsolete behavior

`restore-sysadmin-complete` references an unavailable session snapshot and
terminates GitKraken before attempting restore. Do not run it.
