# Recovery

## Incorrect workspace assignment

Use the approved live-reroute snapshot only after opening the intended managed
windows:

```bash
cosmic-wm restore \
  --timeout 30 \
  --debug \
  sysadmin-managed-reroute-v1-ws1-ws6-no-stale-ws1-browser-2026-08-24
```

## Incorrect in-workspace placement

The current snapshot cannot repair tile geometry or ordering. Arrange windows
manually with COSMIC's normal tiling controls after routing.

Do not repeat restore expecting it to rebuild positions or sizes; it will route
windows again but does not contain layout geometry.

## Generic LibreWolf about:blank window

A generic LibreWolf launch means a snapshot browser matcher was not found.

1. Close the unintended blank window if appropriate.
2. Do not continue rerunning the same snapshot blindly.
3. Identify the stale entry by comparing saved browser titles with:

   ```bash
   cosmic-wm status
   ```

4. Remove or update only the stale app block in a copied snapshot.
5. Preserve WS7 exclusions in every replacement snapshot.
6. Validate the modified snapshot with all intended windows open and a short
   timeout.

## Legacy complete restore

Do not run:

```text
scripts/bin/restore-sysadmin-complete
```

It references an absent `sysadmin-complete-2026-08-24` snapshot and terminates
GitKraken before attempting restore.
