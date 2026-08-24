# Canonical Commands

## Cold start

```bash
~/.local/bin/start-sysadmin-cold
```

## Status

```bash
cosmic-wm status
```

## Approved live reroute

```bash
cosmic-wm restore \
  --timeout 30 \
  --debug \
  sysadmin-managed-reroute-v1-ws1-ws6-no-stale-ws1-browser-2026-08-24
```

## Workspace terminals

```bash
~/bin/open-workspace-terminal 2
~/bin/open-workspace-terminal 3
~/bin/open-workspace-terminal 4
```

## Deprecated or restricted commands

| Artifact | Status |
|---|---|
| `restore-sysadmin-complete` | Do not run; obsolete snapshot name and GitKraken termination |
| `workspace-profile --reset` | Do not treat as canonical; depends on legacy aggregate profile and cleanup manifests |
| `configure-workspace-term.sh` | Historical mutation script |
| `enable-dynamic-sysadmin-workspaces.sh` | Historical patch script |
| `fix-sysadmin-browser-windows.py` | Historical patch script |
| `guard-sysadmin-reset.sh` | Historical patch script |
