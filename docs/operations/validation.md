# Validation

## Inspect current workspace state

```bash
cosmic-wm status
```

Use status output to verify workspace assignments, window classes, and titles
before deciding whether a native reroute is appropriate.

## Validate a native live reroute

Capture state before and after the reroute:

```bash
cosmic-wm status > /tmp/cosmic-before-native-reroute.txt

cosmic-wm restore \
  --timeout 30 \
  --debug \
  sysadmin-managed-reroute-v1-ws1-ws6-no-stale-ws1-browser-2026-08-24

cosmic-wm status > /tmp/cosmic-after-native-reroute.txt

diff -u \
  /tmp/cosmic-before-native-reroute.txt \
  /tmp/cosmic-after-native-reroute.txt | less
```

Verify that the supported native applications moved to their resident
workspaces: Spotify in WS1; dedicated terminals in WS2–WS4; Visual Studio Code
in WS5; and Discord, Slack, Mattermost, Signal, and GitKraken in WS6.

## Confirm WS7 remains outside reroute

Use `cosmic-wm status` to confirm the assistant/control LibreWolf and COSMIC
Terminal activity remains in WS7. The approved native snapshot contains no
workspace-7 rule.

## Confirm browser-free behavior

The approved native snapshot has no LibreWolf or Firefox rule. During a reroute
test, investigate any unexpected browser process spawn; it is not expected
behavior for this snapshot.

## Interpret output carefully

Dynamic application state can change without indicating a routing failure:

- Spotify track titles change.
- Browser page titles and active tabs change.
- Communication-client notification counts change.

Validate workspace number and application identity first. The current tooling
does not validate or restore precise tile layout, geometry, or focus order.
