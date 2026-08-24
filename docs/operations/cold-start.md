# Cold Start

## Canonical command

The canonical cold-start launcher is:

```bash
~/.local/bin/start-sysadmin-cold
```

Its repository copy is:

```text
scripts/local-bin/start-sysadmin-cold
```

It starts these profiles serially, with a 90-second timeout per profile:

```text
sysadmin-ws1
sysadmin-ws2
sysadmin-ws3
sysadmin-ws4
sysadmin-ws5
sysadmin-ws6
```

## Desktop entry

The corresponding desktop entry is:

```text
scripts/desktop/sysadmin-cold-start.desktop
```

Its deployed form invokes:

```text
/home/pjfernandes/.local/bin/start-sysadmin-cold
```

## Validation

After a cold start:

```bash
cosmic-wm status
```

Confirm that expected windows are present in WS1 through WS6. Do not expect
exact tile arrangement, geometry, sizes, or split ratios to be reconstructed by
the current tooling.

## Canonical application commands

The profile files are authoritative. In particular, the tested WS6 commands
are:

```text
/usr/bin/discord
/usr/bin/mattermost-desktop
```

Do not replace them with snapshot-inferred commands such as
`flatpak run com.discordapp.Discord` or `Mattermost.Desktop`.
