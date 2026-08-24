# Validation

## Current desktop state

```bash
cosmic-wm status
```

## Preserve a before/after comparison

```bash
cosmic-wm status > /tmp/cosmic-before-reroute.txt

cosmic-wm restore \
  --timeout 30 \
  --debug \
  sysadmin-managed-reroute-v1-ws1-ws6-no-stale-ws1-browser-2026-08-24

cosmic-wm status > /tmp/cosmic-after-reroute.txt

diff -u /tmp/cosmic-before-reroute.txt /tmp/cosmic-after-reroute.txt | less
```

Dynamic titles can change without indicating a failure. Spotify tracks and
browser page titles commonly change while placement remains stable.

## Confirm WS7

```bash
cosmic-wm status | grep -Ei \
  'start login script pop_os|com\.system76\.CosmicTerm'
```

Expected result: the protected LibreWolf and COSMIC Terminal windows remain on
workspace 7.

## Confirm no browser spawn

During a reroute test, investigate any line containing:

```text
Spawning process: /usr/share/librewolf/librewolf
```

That generally indicates a title-based browser matcher did not find its intended
already-open window.
