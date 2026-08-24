#!/usr/bin/env bash
set -Eeuo pipefail

target="$HOME/bin/startSysadmin.sh"
stamp="$(date +%Y%m%d-%H%M%S)"
backup="${target}.${stamp}.pre-reset-guard.bak"
tmp="$(mktemp "${target}.XXXXXX")"

cleanup() {
  rm -f -- "$tmp"
}
trap cleanup EXIT

[[ -f "$target" ]] || {
  echo "ERROR: Missing launcher: $target" >&2
  exit 1
}

cp -a -- "$target" "$backup"

awk '
BEGIN {
  in_reset = 0
  replaced = 0
}
$0 == "if [[ -n \"$RESET_MODE\" || -n \"$RESET_APP_ID\" ]]; then" {
  if (replaced) {
    print
    next
  }

  in_reset = 1
  replaced = 1
  print "if [[ -n \"$RESET_MODE\" || -n \"$RESET_APP_ID\" ]]; then"
  print "  cat >&2 <<'\''RESET_GUARD_EOF'\''"
  print "ERROR: --reset is temporarily unavailable."
  print ""
  print "The legacy aggregate \"sysadmin\" profile was archived. The previous reset"
  print "implementation closed applications globally by app ID, which cannot safely"
  print "separate LibreWolf windows across managed workspaces or protect the computed"
  print "edit/control workspace."
  print ""
  print "No windows have been changed."
  print ""
  print "Use normal serial profile reconciliation only when planned:"
  print "  startSysadmin.sh"
  print ""
  print "Workspace-scoped live-window reset will be added separately."
  print "RESET_GUARD_EOF"
  print "  exit 2"
  print "fi"
  next
}

in_reset {
  if ($0 == "fi") {
    in_reset = 0
  }
  next
}

{ print }

END {
  if (!replaced) {
    exit 42
  }
}
' "$target" > "$tmp" || {
  status=$?
  if [[ "$status" -eq 42 ]]; then
    echo "ERROR: Legacy reset block was not found; no changes made." >&2
  else
    echo "ERROR: Failed to transform launcher; no changes made." >&2
  fi
  exit "$status"
}

bash -n "$tmp"
mv -- "$tmp" "$target"

printf 'Installed safe reset guard.\nBackup: %s\n' "$backup"
