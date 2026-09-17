# Canonical Commands

## Cold start

Start the complete managed WS1–WS6 set:

```bash
~/.local/bin/start-sysadmin-cold
```

Use cold start when intended profile-defined applications or managed LibreWolf
windows need to be launched.

## Workspace profile chooser

Open the graphical profile chooser:

```bash
~/bin/launch-workspace-profile --prompt
```

Select `sysadmin` to invoke `~/.local/bin/start-sysadmin-cold`.

For the command-line compatibility launcher:

```bash
workspace-profile --profile sysadmin
```

## Native live reroute

Use only when a supported native application window is already open and needs
to be returned to its resident workspace:

```bash
cosmic-wm restore \
  --timeout 30 \
  --debug \
  sysadmin-managed-reroute-v1-ws1-ws6-no-stale-ws1-browser-2026-08-24
```

The YAML name is `sysadmin-live-native-reroute`. Its ten supported native rules
are Spotify; the WS2, WS3, and WS4 dedicated terminals; Visual Studio Code; and
Discord, Slack, Mattermost, Signal, and GitKraken.

It has no browser rules. Do not use it to start missing applications, launch
LibreWolf, move browser windows, or manage WS7.

## Status

Inspect current COSMIC workspace/window state:

```bash
cosmic-wm status
```

## Workspace terminals

Open a dedicated terminal with its stable class:

```bash
~/bin/open-workspace-terminal 2
~/bin/open-workspace-terminal 3
~/bin/open-workspace-terminal 4
```

## Restricted commands and artifacts

| Artifact | Status |
|---|---|
| `~/bin/backups/workspace-manager-cleanup-20260917-150404/` | Legacy archive for audit/rollback only |
| Archived `startSysadmin.sh` | Do not run; replaced by `~/.local/bin/start-sysadmin-cold` |
| Archived `restore-sysadmin-complete` | Do not run; obsolete snapshot and unsafe behavior |
| Historical patch, conversion, and browser helper scripts | Do not run; retained in the dated archive |
| `pkill librewolf` | Do not use for selective cleanup; may close unrelated or WS7 browser work |
