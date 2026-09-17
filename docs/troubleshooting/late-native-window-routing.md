# Late Native Window Routing

## When this applies

Use this procedure when one of the supported native applications starts or
appears on the wrong workspace after the managed workspace set is already in
use.

The supported rules are:

- Spotify for WS1
- Dedicated workspace terminals for WS2, WS3, and WS4
- Visual Studio Code for WS5
- Discord, Slack, Mattermost, Signal, and GitKraken for WS6

## Procedure

1. Confirm the application is already open.
2. Inspect its class and current workspace with:

   ```bash
   cosmic-wm status
   ```

3. Confirm it is one of the supported native live-reroute rules.
4. Run the approved native reroute:

   ```bash
   cosmic-wm restore \
     --timeout 30 \
     --debug \
     sysadmin-managed-reroute-v1-ws1-ws6-no-stale-ws1-browser-2026-08-24
   ```

5. Run `cosmic-wm status` again and verify the resident workspace.

## Do not use live reroute when

- The application is LibreWolf or another browser window
- The application is not one of the ten native rules
- You need to restore tile geometry or ordering
- The window belongs to WS7

In those cases, move the identified window manually or use the owning cold-start
profile when the application needs to be launched.
