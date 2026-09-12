# WS4 shared LibreWolf launch migration

Timestamp: 20260912-125113

Changed file:

`profiles/sysadmin-ws4.yaml`

Local backup:

`/home/pjfernandes/Projects/ct/cosmic-wm-workspace-manager/profiles/sysadmin-ws4.yaml.20260912-125113.pre-shared-librewolf.bak`

Changes:

- Removed the dedicated LibreWolf launch-profile arguments for CT Codex Home Assistant documentation.
- Removed the dedicated LibreWolf launch-profile arguments for the Home Assistant dashboard.
- Removed the dedicated LibreWolf launch-profile arguments for the Perplexity Home Automation project.
- Retained each URL, workspace 4 assignment, title matcher, comments, and terminal entry.
- All three WS4 browser windows now launch through the normal/shared LibreWolf session with `--new-window`.

Not changed:

- The physical LibreWolf profile directories; they remain available as rollback assets.
- WS4 terminal configuration.
- Browser URLs, COSMIC placement matchers, and workspace numbering.
- Other workspace profile files.
