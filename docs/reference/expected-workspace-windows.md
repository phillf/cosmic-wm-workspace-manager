# Expected managed workspace windows

This inventory defines the expected applications launched and routed by the
canonical cold-start profiles:

- `profiles/sysadmin-ws1.yaml`
- `profiles/sysadmin-ws2.yaml`
- `profiles/sysadmin-ws3.yaml`
- `profiles/sysadmin-ws4.yaml`
- `profiles/sysadmin-ws5.yaml`
- `profiles/sysadmin-ws6.yaml`

The profile YAML files are the source of truth. This document is a
human-readable validation reference and must be updated in the same commit as
any profile change that adds, removes, or materially changes a managed
application.

## Shared LibreWolf model

All profile-managed browser windows use the normal shared LibreWolf session:

```text
/usr/bin/librewolf --new-window <URL>
```

A profile-managed browser window is distinct from unrelated LibreWolf windows
or tabs that may also be open. COSMIC routing is governed by the configured
`class` and `title` fields in the canonical profile, rather than by incidental
runtime suffixes such as `Original profile — LibreWolf`.

## Workspace 1 — General

| Managed window | Launch target | Matcher | Notes |
|---|---|---|---|
| YouTube | `https://www.youtube.com/` | `class: librewolf`; title: `YouTube` | Shared LibreWolf window |
| Spotify | `spotify` | `class: Spotify` | Native desktop application |

## Workspace 2 — Infrastructure

| Managed window | Launch target | Matcher | Notes |
|---|---|---|---|
| Workspace terminal | `/home/pjfernandes/bin/workspace-term 2` | `class: me.creativetech.terminal.workspace2` | Dedicated terminal |
| PVE / Portainer | `https://pve.creativetech.me/` | `class: librewolf`; title: `Proxmox Virtual Environment` | Shared LibreWolf window; Portainer opens as a secondary tab |
| PBS / PDM | `https://pbs.creativetech.me/` | `class: librewolf`; title: `Proxmox Backup Server` | Shared LibreWolf window; PDM opens as a secondary tab |
| GitLab | `https://git.creativetech.me/` | `class: librewolf`; title: `GitLab` | Shared LibreWolf window |
| CT Codex / Atlas | `https://codex.creativetech.me/ops/` | `class: librewolf`; title: `Ops \| CT Codex` | Shared LibreWolf window; Atlas opens as a secondary tab |

## Workspace 3 — Observability

| Managed window | Launch target | Matcher | Notes |
|---|---|---|---|
| Workspace terminal | `/home/pjfernandes/bin/workspace-term 3` | `class: me.creativetech.terminal.workspace3` | Dedicated terminal |
| Grafana Cloud | `https://creativetech.grafana.net/login/` | `class: librewolf`; title: `Grafana` | Shared LibreWolf window |

The MBTA browser window sometimes used during routing verification is a
temporary placeholder. It is not profile-defined and is not required for WS3.

## Workspace 4 — Home Automation

| Managed window | Launch target | Matcher | Notes |
|---|---|---|---|
| CT Codex Home Assistant documentation | `https://codex.creativetech.me/docker-stacks/docker02/homeassistant/?_highlight=home&_highlight=ass` | `class: librewolf`; title: `Home Assistant \| CT Codex` | Shared LibreWolf window |
| Home Assistant dashboard | `https://ha-tst.creativetech.me/home/overview` | `class: librewolf`; title: `Home Assistant` | Shared LibreWolf window |
| Workspace terminal | `/home/pjfernandes/bin/workspace-term 4` | `class: me.creativetech.terminal.workspace4` | Dedicated terminal |
| Perplexity Home Automation project | `https://www.perplexity.ai/projects/ceb715a6-26e6-49e4-af03-97308d473ef3` | `class: librewolf`; title: `Home Automation \| Perplexity` | Shared LibreWolf window |

## Workspace 5 — Development

| Managed window | Launch target | Matcher | Notes |
|---|---|---|---|
| Visual Studio Code | `code` | `class: code` | Native desktop application |

## Workspace 6 — Communications

| Managed window | Launch target | Matcher | Notes |
|---|---|---|---|
| Slack | `slack` | `class: Slack` | Native desktop application |
| Discord | `/usr/bin/discord` | `class: discord` | Native desktop application |
| GitKraken Desktop | `gitkraken` | `class: gitkraken`; title: `GitKraken Desktop` | Native desktop application |
| Signal | `signal-desktop` | `class: signal` | Native desktop application |
| Mattermost Desktop | `/usr/bin/mattermost-desktop` | `class: Mattermost.Desktop` | Native desktop application |

## Validation procedure

Launch one profile at a time:

```bash
cosmic-wm start sysadmin-ws4 --timeout 150
```

Inspect current window routing:

```bash
cosmic-wm status
```

A validation pass requires every application declared in the relevant profile
to be found in its configured workspace. Manually opened applications,
unrelated browser windows, and documented verification placeholders are out
of scope.

During shared LibreWolf reuse, the visible active-tab title can differ from the
profile's intended launch-page title. Validation should prioritize the runner's
successful configured matcher result and workspace placement; close or reset
pre-existing managed browser windows when validating exact page identity.
