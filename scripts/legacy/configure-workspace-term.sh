#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

[[ $EUID -ne 0 ]] || {
  echo "Do not run this script with sudo." >&2
  exit 1
}

WEZTERM_CONFIG="$HOME/.wezterm.lua"
WORKSPACE_TERM="$HOME/bin/workspace-term"
COSMIC_WM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/cosmic-wm"
COSMIC_WM_LAYOUT="${COSMIC_WM_LAYOUT:-$COSMIC_WM_CONFIG_DIR/layouts/sysadmin.yaml}"
BACKUP_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/workspace-terminal-config/backups/$(date +%Y%m%d-%H%M%S)"

command -v wezterm >/dev/null 2>&1 || {
  echo 'WezTerm is not installed. Install it, then rerun this script.' >&2
  exit 1
}

mkdir -p "$HOME/bin" "$BACKUP_DIR"

backup_file() {
  local source="$1"

  [[ -e "$source" ]] || return 0

  cp -a "$source" "$BACKUP_DIR/$(basename "$source")"
  printf '[backup] %s -> %s\n' "$source" "$BACKUP_DIR"
}

backup_file "$WEZTERM_CONFIG"
backup_file "$WORKSPACE_TERM"

if [[ -e "$COSMIC_WM_LAYOUT" ]]; then
  backup_file "$COSMIC_WM_LAYOUT"
else
  cat >&2 <<EOF
Warning: cosmic-wm layout was not found at:

  $COSMIC_WM_LAYOUT

The WezTerm configuration and workspace-term launcher will be written,
but the Spotify layout patch will be skipped.

To patch a non-default layout location, rerun with:

  COSMIC_WM_LAYOUT=/path/to/sysadmin.yaml $0
EOF
fi

cat >"$WEZTERM_CONFIG" <<'EOF'
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Preserve a workspace title set by workspace-term.  This prevents the shell,
-- prompt, SSH, tmux, or foreground programs from replacing the COSMIC-visible
-- title with "bash", a hostname, or a command name.
wezterm.on('format-window-title', function(window, pane)
  local workspace_title = os.getenv('WS_WINDOW_TITLE')

  if workspace_title and workspace_title ~= '' then
    return workspace_title
  end

  local title = pane:get_title()

  if title and title ~= '' then
    return title
  end

  return 'WezTerm'
end)

return config
EOF

cat >"$WORKSPACE_TERM" <<'EOF'
#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

workspace="${1:?Usage: workspace-term <workspace-number>}"

command -v wezterm >/dev/null 2>&1 || {
  echo "WezTerm is not installed." >&2
  exit 1
}

case "$workspace" in
  2)
    app_id="me.creativetech.terminal.workspace2"
    title="CT Workspace 2 Terminal"
    label="workspace2"
    ;;
  3)
    app_id="me.creativetech.terminal.workspace3"
    title="CT Workspace 3 Terminal"
    label="workspace3"
    ;;
  4)
    app_id="me.creativetech.terminal.workspace4"
    title="CT Workspace 4 Terminal"
    label="workspace4"
    ;;
  *)
    echo "Unsupported workspace: $workspace" >&2
    exit 2
    ;;
esac

export WS_LABEL="$label"
export WS_WINDOW_TITLE="$title"

exec wezterm start \
  --always-new-process \
  --class "$app_id" \
  -- bash -lc 'exec "$SHELL"'
EOF

chmod 0755 "$WORKSPACE_TERM"

bash -n "$WORKSPACE_TERM"

if [[ -f "$COSMIC_WM_LAYOUT" ]]; then
  python3 - "$COSMIC_WM_LAYOUT" <<'PYTHON'
from pathlib import Path
import re
import sys

layout_path = Path(sys.argv[1])
text = layout_path.read_text(encoding="utf-8")

old_rule = """  # Workspace 1 — music
  - command: spotify
    workspace: 1
    match:
      title: "Spotify Premium"
"""

new_rule = """  # Workspace 1 — Spotify main window
  # COSMIC reports the main client as App ID "Spotify"; track metadata
  # changes constantly, so do not match its title.
  - command: spotify
    workspace: 1
    match:
      class: Spotify
"""

if old_rule in text:
    layout_path.write_text(text.replace(old_rule, new_rule, 1), encoding="utf-8")
    print(f"[updated] Spotify rule in {layout_path}")
    sys.exit(0)

if re.search(r'(?ms)^  - command: spotify\n    workspace: 1\n    match:\n(?:      .*\n)+', text):
    print(f"[skipped] A workspace-1 Spotify rule exists but does not match the expected old form: {layout_path}")
    print("          Update it manually to: class: Spotify")
    sys.exit(0)

insertion_point = "\n  # Workspace 5 — code and music controls\n"
if insertion_point in text:
    text = text.replace(
        insertion_point,
        """\n  # Workspace 1 — Spotify main window
  - command: spotify
    workspace: 1
    match:
      class: Spotify
""" + insertion_point,
        1,
    )
    layout_path.write_text(text, encoding="utf-8")
    print(f"[added] Spotify rule in {layout_path}")
    sys.exit(0)

print(f"[skipped] Could not identify an insertion point in {layout_path}")
print("          Add this rule manually:")
print('''
  - command: spotify
    workspace: 1
    match:
      class: Spotify
'''.rstrip())
PYTHON
fi

cat <<EOF

Configuration complete.

Backups:
  $BACKUP_DIR

Written:
  $WEZTERM_CONFIG
  $WORKSPACE_TERM

Validation:
  bash -n $WORKSPACE_TERM

Next steps:
  1. Close the existing workspace-term windows in COSMIC.
  2. Launch fresh windows:

       $WORKSPACE_TERM 2
       $WORKSPACE_TERM 3
       $WORKSPACE_TERM 4

  3. Reload/reapply your cosmic-wm layout using the same mechanism you
     normally use for the sysadmin layout.
  4. Close the existing Spotify main window and relaunch Spotify so the
     updated class-based rule can place it on workspace 1.

Expected terminal titles:
  CT Workspace 2 Terminal
  CT Workspace 3 Terminal
  CT Workspace 4 Terminal
EOF
