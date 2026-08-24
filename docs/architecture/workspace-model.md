# Workspace Model

## Managed range

The managed workstation range is WS1 through WS6.

| Workspace | Intended role | Key managed examples |
|---|---|---|
| WS1 | General/ambient | Spotify and optional general browser activity |
| WS2 | Infrastructure administration | WS2 terminal, PVE, PBS, GitLab, Ops \| CT Codex |
| WS3 | Observability | WS3 terminal and Grafana |
| WS4 | Automation | WS4 terminal, Perplexity, Home Assistant |
| WS5 | Development | Visual Studio Code |
| WS6 | Communications | Discord, Slack, Mattermost, Signal, GitKraken |
| WS7 | Protected control workspace | Assistant/control LibreWolf and COSMIC Terminal |

## WS7 protection

WS7 is not part of the managed reroute workflow. The approved snapshot excludes
the WS7 LibreWolf and COSMIC Terminal entries.

If a future active workspace occupies WS7, move the protected assistant/control
workspace to the next available workspace and update both documentation and
snapshot-selection controls before using restore.

## Terminal identities

Workspaces 2, 3, and 4 use dedicated WezTerm classes to make routing stable:

| Workspace | Class | Expected title |
|---|---|---|
| WS2 | `me.creativetech.terminal.workspace2` | `CT Workspace 2 Terminal` |
| WS3 | `me.creativetech.terminal.workspace3` | `CT Workspace 3 Terminal` |
| WS4 | `me.creativetech.terminal.workspace4` | `CT Workspace 4 Terminal` |

Use `scripts/bin/open-workspace-terminal` to open these supported terminal
windows.
