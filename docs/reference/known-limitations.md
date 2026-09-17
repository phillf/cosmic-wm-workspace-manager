# Known Limitations

## Layout restore is not available

The current COSMIC workspace manager/session arrangement routes supported
native windows to their resident workspaces. It does not restore:

- Tile order
- Left/right/top/bottom placement
- Split orientation or ratios
- Window size
- Floating coordinates
- Stack or tab-group membership
- Focus order
- Monitor-specific geometry

## Live reroute is native-only

The approved live-reroute YAML has ten supported native application rules. It
contains no LibreWolf or Firefox command, class matcher, or title matcher.

Browser windows, browser tabs, page identity, and browser placement are outside
live reroute. The cold-start profiles own intentional browser launches.

## Browser state is dynamic

Managed profile browser windows use the shared LibreWolf session. Navigation,
authentication, active-tab changes, redirects, page updates, and user actions
can change browser titles and organization after startup.

Do not use broad process termination such as `pkill librewolf` to correct a
single browser issue. Close or move only the identified window.

## Snapshot versus cold start

A live reroute is not a substitute for the canonical serial cold-start profiles.
Use cold start to start the managed workspace set. Use native reroute only to
correct already-open supported native windows.

## WS7 is protected by policy

The approved reroute snapshot excludes WS7. Validate any newly created or
modified reroute snapshot before use:

```bash
grep -n -A4 -B1 '^  workspace: 7$' \
  ~/.config/cosmic-wm-manager/sessions/NAME.yaml
```

No output is expected for a WS1–WS6-only native reroute snapshot.
