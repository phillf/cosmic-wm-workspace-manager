# Browser Boundaries

## Browser ownership

LibreWolf windows that belong to the managed workspace arrangement are defined
by the WS1–WS4 cold-start profiles. The live reroute snapshot has a strict
browser-free boundary.

```text
Cold-start profiles: may launch intended LibreWolf windows
Live native reroute: must not launch, match, or move LibreWolf windows
```

## Why the boundary exists

The session-restore mechanism can match windows using titles. Browser titles are
not stable identifiers: redirects, authentication, active-tab changes, page
updates, and user navigation can change them. A failed browser match can lead
to an unwanted generic browser launch.

The approved native-only snapshot eliminates that failure mode by containing no
LibreWolf entries.

## Operator guidance

- Start expected browser windows through their owning cold-start workspace
  profile.
- Treat browser placement and tab organization as manual responsibilities after
  a live native reroute.
- Do not add a generic `/usr/bin/librewolf` command to a reroute snapshot.
- Do not use `pkill librewolf` as selective cleanup; it can terminate unrelated
  browser work, including protected WS7 activity.
- If an unwanted browser window appears, close only the identified unwanted
  window through the desktop environment after confirming it is not needed.

## Shared session model

The managed profile browser windows use the normal shared LibreWolf session.
They are not isolated browser-profile instances. This preserves existing
browser authentication and session state, but it also means operators should
avoid broad browser termination or automated browser cleanup actions.

## WS7 boundary

The assistant/control LibreWolf window on WS7 is not managed by the cold-start
profiles or by native live reroute. Preserve it as independent user work.
