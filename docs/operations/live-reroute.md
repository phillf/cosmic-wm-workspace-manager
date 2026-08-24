# Live Reroute

## Approved snapshot

```text
sysadmin-managed-reroute-v1-ws1-ws6-no-stale-ws1-browser-2026-08-24
```

Repository file:

```text
sessions/sysadmin-managed-reroute-v1-ws1-ws6-no-stale-ws1-browser-2026-08-24.yaml
```

It contains 17 managed applications for WS1 through WS6. It excludes WS7 and
the stale WS1 LibreWolf matcher that previously launched a generic browser
window.

## Preconditions

- All intended managed windows are already open.
- WS7 is treated as protected.
- You accept that routing may change the current in-workspace tiling insertion
  order.
- You have checked that browser titles still correspond to the saved matchers.

## Run

```bash
cosmic-wm restore \
  --timeout 30 \
  --debug \
  sysadmin-managed-reroute-v1-ws1-ws6-no-stale-ws1-browser-2026-08-24
```

A successful run ends with:

```text
All application windows matched and successfully organized
```

## Success criteria

- 17 existing windows are reused.
- No `Spawning process: /usr/share/librewolf/librewolf` message appears.
- No timeout occurs.
- Managed windows are routed to WS1 through WS6.
- WS7 windows remain on WS7.

## Important limitation

This is a workspace-routing workflow only. It does not restore the preferred
tile order, position, size, split ratio, floating geometry, or stack/tab layout.
