# Reading `cosmic-wm status`

## Purpose

Use `cosmic-wm status` as the first diagnostic tool before cold start, native
reroute, manual placement, or snapshot maintenance.

It provides the current workspace/window state needed to identify application
class, title, and workspace assignment.

## What to verify

For a managed-window issue, confirm:

- The application is open
- Its current workspace number
- Its application class
- Its visible title, when a title matcher is relevant
- Whether it is a supported native live-reroute application
- Whether it belongs to protected WS7 activity

## Expected native placement

| Workspace | Native applications covered by live reroute |
|---|---|
| WS1 | Spotify |
| WS2 | Dedicated WS2 terminal |
| WS3 | Dedicated WS3 terminal |
| WS4 | Dedicated WS4 terminal |
| WS5 | Visual Studio Code |
| WS6 | Discord, Slack, Mattermost, Signal, GitKraken |
| WS7 | No managed reroute entries |

## Dynamic values

Titles may change without a routing failure. Examples include Spotify tracks,
browser pages, active browser tabs, notification counts, and communication
client status.

Use application identity and workspace assignment as the primary validation
criteria. Do not interpret a changed browser title as a reason to add it to
native live reroute.
