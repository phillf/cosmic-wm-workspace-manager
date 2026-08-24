# Restore Boundaries

## Two different operations

A cold start and a live reroute solve different problems.

| Operation | Source | Purpose |
|---|---|---|
| Cold start | `profiles/sysadmin-ws1.yaml` through `sysadmin-ws6.yaml` | Start the normal managed workspace set |
| Live reroute | Approved 17-window session snapshot | Reassign already-open matched windows to WS1–WS6 |

## What snapshot restore does

The snapshot records application launch commands, a workspace destination, and
window match criteria such as app class and title. It can reuse a matching open
window and route it to the assigned workspace.

## What snapshot restore does not do

The saved session schema does not contain a tile tree, split orientation,
in-workspace ordering, split ratios, floating coordinates, dimensions, stack
membership, tab group state, or focus order.

Therefore successful output such as:

```text
All application windows matched and successfully organized
```

means windows were matched and assigned to workspaces. It does not mean the
original visual workspace layout was restored.

## Browser matching risk

LibreWolf snapshot entries are title-dependent. If a saved title no longer
matches an open browser window, restore may treat it as missing and execute a
generic browser command. A generic command can create an `about:blank` window.

The approved snapshot removes the stale WS1 browser matcher that previously
caused this behavior. Other title-based browser matchers remain sensitive to
title changes and must be used only when the intended windows are already open.
