# COSMIC Layout-Restore Feature Request

## Title

```text
Restore saved workspace window layouts, including tile order and floating geometry
```

## Submission body

```markdown
**Is your feature request related to a problem? Please describe.**

After a reboot, login, monitor reconnect, or accidental workspace rearrangement,
I can restore applications to their intended COSMIC workspaces, but I cannot
restore the actual layout within each workspace.

For example, several application windows can be returned to Workspace 2, but
they are not restored to their previous tile positions, ordering, split sizes,
or stack/tab groups. Floating windows also do not return to their previous size
and position.

This makes rebuilding a multi-workspace administrative or development desktop
manual and time-consuming.

**Describe the solution you'd like**

Please provide an opt-in native way to save and restore workspace layouts.

A saved layout should ideally preserve:

- Window-to-workspace and window-to-output assignment.
- Tiled versus floating state.
- Tiling structure: split direction, window order, stacks/tab groups, and
  split ratios.
- Floating window size and position.
- Maximized/fullscreen state where practical.

On restore, COSMIC should match already-open windows first, optionally start
missing applications, then reconstruct the selected workspace layouts as
closely as possible. Any windows that cannot be matched should be reported
clearly rather than silently opening generic replacement windows.

A documented user-facing feature, CLI, or session-scoped IPC/API would enable
both manual recovery and third-party tooling.

**Describe alternatives you've considered**

Currently I can:

- Manually rebuild the layout after applications have been routed to the
  correct workspace.
- Use tools that route or launch applications by workspace.

Neither option restores the placement, sizing, tiling tree, or floating geometry
of an established working layout.

**Additional context**

This would be especially useful for stable, role-based workspaces—for example,
operations, development, communications, or multi-monitor administrative
desktops—where the same applications are used daily in the same arrangement.

Related request: #2439, which discusses a CLI for controlling windows and notes
the need to query and explicitly set window positions. This request extends that
need to saving and restoring complete workspace layouts.

Disclosure: I used Perplexity AI to help draft and organize this feature
request. The described use case, testing, and requested behavior reflect my own
experience using COSMIC.
```
