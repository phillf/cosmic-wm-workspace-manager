# Browser Duplicates

## Scope

The approved live reroute is browser-free. It must not start, match, or move
LibreWolf windows. This procedure applies if an unwanted browser window already
exists or if a historical browser-aware workflow was used previously.

## Safe response

1. Inspect the current browser windows and identify the specific unwanted one.
2. Confirm that it is not a required WS1–WS4 managed browser window and not
   protected WS7 assistant/control work.
3. Close only that confirmed unwanted window through the desktop environment.
4. Do not rerun a historical browser-aware snapshot.
5. Do not add a generic LibreWolf command to the native reroute snapshot.
6. Recheck workspace state with `cosmic-wm status`.

## Never use broad termination

Do not run:

```bash
pkill librewolf
```

Managed browser windows use the shared LibreWolf session. Broad termination can
close unrelated work and protected WS7 activity.

## Prevent recurrence

- Start intended managed browser windows through their owning cold-start
  profiles.
- Keep LibreWolf out of live reroute YAML.
- Use native reroute only for the supported native application rules.
- Treat browser placement and tab organization as manual work after a native
  reroute.
