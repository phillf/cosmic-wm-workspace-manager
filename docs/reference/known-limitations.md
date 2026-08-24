# Known Limitations

## Layout restore is not available

The current COSMIC workspace manager/session snapshot arrangement correctly
routes matched windows to resident workspaces. It does not restore:

- Tile order.
- Left/right/top/bottom placement.
- Split orientation or ratios.
- Window size.
- Floating coordinates.
- Stack or tab-group membership.
- Focus order.
- Monitor-specific geometry.

## Browser entries are title-sensitive

LibreWolf entries use class and title matching. Redirects, page changes,
title changes, closed tabs, or different browser-window organization can make a
snapshot entry fail to match.

When a match fails, generic LibreWolf launch commands can create an
`about:blank` window. The approved snapshot removes one known stale WS1 entry,
but title sensitivity remains a general limitation.

## Snapshot versus cold start

A snapshot is not a substitute for the canonical serial cold-start profiles.
Use profiles to start the workspace set. Use the approved snapshot only to
reroute already-open windows.

## WS7 is protected by policy, not compositor geometry

The approved snapshot excludes WS7. Always validate a newly created or modified
snapshot before use:

```bash
grep -n -A4 -B1 '^  workspace: 7$' \
  ~/.config/cosmic-wm-manager/sessions/NAME.yaml
```

No output is the expected result for a WS1–WS6-only reroute snapshot.
