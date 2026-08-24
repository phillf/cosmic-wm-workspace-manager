#!/usr/bin/env bash
set -Eeuo pipefail

target="$HOME/bin/startSysadmin.sh"
stamp="$(date +%Y%m%d-%H%M%S)"
backup="${target}.${stamp}.pre-dynamic-workspaces.bak"

[[ -f "$target" ]] || {
  echo "ERROR: Missing launcher: $target" >&2
  exit 1
}

cp -a -- "$target" "$backup"

python3 - "$target" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
text = path.read_text()

old = '''run_workspace_profile sysadmin-ws1 60
run_workspace_profile sysadmin-ws2 150
run_workspace_profile sysadmin-ws3 60
run_workspace_profile sysadmin-ws4 150
run_workspace_profile sysadmin-ws5 60
run_workspace_profile sysadmin-ws6 90
'''

new = '''PROFILE_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/cosmic-wm-manager/profiles"
declare -a MANAGED_PROFILES=()

while IFS= read -r profile; do
  MANAGED_PROFILES+=("$profile")
done < <(
  find "$PROFILE_DIR" -maxdepth 1 -type f -printf '%f\\n' 2>/dev/null |
    sed -nE 's/^sysadmin-ws([0-9]+)\\.yaml$/\\1/p' |
    sort -n
)

(( ${#MANAGED_PROFILES[@]} > 0 )) || {
  echo "ERROR: No managed sysadmin-wsN.yaml profiles found in $PROFILE_DIR" >&2
  exit 1
}

highest_workspace="${MANAGED_PROFILES[-1]}"
edit_workspace=$((highest_workspace + 1))

printf '\\n==> Managed workspaces:'
for workspace in "${MANAGED_PROFILES[@]}"; do
  printf ' WS%s' "$workspace"
done
printf '\\n==> Protected edit workspace: WS%s\\n' "$edit_workspace"

workspace_timeout() {
  case "$1" in
    2|4) printf '150' ;;
    6)   printf '90' ;;
    *)   printf '60' ;;
  esac
}

for workspace in "${MANAGED_PROFILES[@]}"; do
  run_workspace_profile "sysadmin-ws${workspace}" "$(workspace_timeout "$workspace")"
done
'''

if old not in text:
    raise SystemExit(
        "ERROR: Fixed sysadmin-ws1..ws6 dispatch block was not found; no changes made."
    )

path.write_text(text.replace(old, new, 1))
PY

bash -n "$target"

printf 'Installed dynamic workspace discovery.\\nBackup: %s\\n' "$backup"
