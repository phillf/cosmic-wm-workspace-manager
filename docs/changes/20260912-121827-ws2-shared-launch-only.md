# WS2 shared LibreWolf launch migration

Timestamp: 20260912-121827

Changed file:

`profiles/sysadmin-ws2.yaml`

Backup:

`/home/pjfernandes/Projects/ct/cosmic-wm-workspace-manager/profiles/sysadmin-ws2.yaml.20260912-121827.pre-shared-launch-ws2.bak`

Changes:

- Removed only the isolated LibreWolf launch arguments for WS2 PVE/Portainer.
- Removed only the isolated LibreWolf launch arguments for WS2 PBS/PDM.
- Removed only the isolated LibreWolf launch arguments for WS2 Codex/Atlas.
- Retained the previously migrated shared GitLab launcher.
- Retained URLs, paired-tab layout, workspace assignments, and match rules.

Not changed:

- The live/default LibreWolf profile and user.js.
- Cookies, history, bookmarks, saved logins, or open browser windows.
- WS1, WS3, WS4, WS5, or WS6.
- Old isolated profile directories.
- COSMIC session snapshots.
