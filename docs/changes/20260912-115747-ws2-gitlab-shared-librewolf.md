# WS2 GitLab shared LibreWolf migration

Timestamp: 20260912-115747

Changed file:

`profiles/sysadmin-ws2.yaml`

Backup:

`/home/pjfernandes/Projects/ct/cosmic-wm-workspace-manager/profiles/sysadmin-ws2.yaml.20260912-115747.pre-shared-librewolf-gitlab.bak`

Change:

- Removed the dedicated `sysadmin-ws2-gitlab` LibreWolf profile argument.
- Retained the GitLab URL, workspace 2, and existing title matcher.
- GitLab will now open in the normal/shared LibreWolf profile.

Not changed:

- WS2 PVE / Portainer
- WS2 PBS / PDM
- WS2 Codex / Atlas
- WS4 browser configuration
- LibreWolf browser data
- COSMIC session snapshots
