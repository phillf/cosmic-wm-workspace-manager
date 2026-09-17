# Workspace Model

## Managed range

The managed operational workspace range is WS1 through WS6. These workspaces
are started by the `sysadmin-wsN` cold-start profiles and may be corrected later
by the approved native-only live-reroute snapshot.

| Workspace | Intended role | Managed applications and services |
|---|---|---|
| WS1 | General and ambient activity | Spotify and the cold-start YouTube LibreWolf window |
| WS2 | Infrastructure administration | Dedicated terminal; PVE/Portainer, PBS/PDM, GitLab, and CT Codex/Atlas LibreWolf windows |
| WS3 | Observability | Dedicated terminal and Grafana LibreWolf window |
| WS4 | Automation | Dedicated terminal; CT Codex Home Assistant documentation, Home Assistant dashboard, and Perplexity LibreWolf windows |
| WS5 | Development | Visual Studio Code only |
| WS6 | Communications and client tools | Slack, Discord, GitKraken, Signal, and Mattermost |

## WS7 protection

WS7 is a protected assistant/control workspace. It is not part of the managed
cold-start profile range and is deliberately excluded from the approved
native-only reroute snapshot.

Do not add WS7 applications to a managed reroute snapshot. If the protected
assistant/control work moves to another workspace in the future, update the
workspace model and reroute boundary documentation before changing a snapshot.

## Launch and routing ownership

The workspace system has two distinct owners:

| Owner | Responsibility | Browser behavior |
|---|---|---|
| Cold-start profiles | Start the managed workspace applications for WS1–WS6 | Profiles own intended LibreWolf launches |
| Native-only live reroute | Reassign matching, already-open native application windows to WS1–WS6 | Contains no browser rules and must not launch LibreWolf |

A live reroute is not a second startup system. It is a corrective placement
operation for supported native application windows that are already open.

## Terminal identities

Workspaces 2, 3, and 4 use dedicated WezTerm classes to make native routing
stable:

| Workspace | Class | Expected title |
|---|---|---|
| WS2 | `me.creativetech.terminal.workspace2` | `CT Workspace 2 Terminal` |
| WS3 | `me.creativetech.terminal.workspace3` | `CT Workspace 3 Terminal` |
| WS4 | `me.creativetech.terminal.workspace4` | `CT Workspace 4 Terminal` |

Use `scripts/bin/open-workspace-terminal` through its active `~/bin`
compatibility entrypoint to open these supported terminal windows.
