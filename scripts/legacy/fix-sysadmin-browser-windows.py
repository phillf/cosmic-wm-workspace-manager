from pathlib import Path
from datetime import datetime
import re
import shutil
import sys

profile = Path.home() / ".config/cosmic-wm-manager/profiles/sysadmin.yaml"

if not profile.is_file():
    raise SystemExit(f"ERROR: Missing profile: {profile}")

source = profile.read_text(encoding="utf-8")

if 'title: "Portainer"' in source or "title: Portainer" in source:
    raise SystemExit("No change: a dedicated Portainer rule already exists.")

pattern = re.compile(
    r'''(?ms)^  # PVE is first so its title identifies the LibreWolf administration window\.\n
^  # The PVE cluster is managed from its primary web interface; pve2 is omitted\.\n
^  # PBS and PDM live here with the other Proxmox administration tools\.\n
^  - command: >-\n
^      /usr/bin/librewolf --new-window\n
^      https://pve\.creativetech\.me/\n
^      https://portainer\.creativetech\.me/\n
^      https://codex\.creativetech\.me/\n
^      https://git\.creativetech\.me/\n
^      https://pbs\.creativetech\.me/\n
^      https://pdm\.creativetech\.me/\n
^    workspace: 2\n
^    match:\n
^      class: librewolf\n
^      title: "Proxmox Virtual Environment"\n''',
)

replacement = '''  # Workspace 2 primary Proxmox administration window.
  # Keep related tools as tabs in the PVE window.
  - command: >-
      /usr/bin/librewolf --new-window
      https://pve.creativetech.me/
      https://codex.creativetech.me/
      https://git.creativetech.me/
      https://pbs.creativetech.me/
      https://pdm.creativetech.me/
    workspace: 2
    match:
      class: librewolf
      title: "Proxmox Virtual Environment"

  # Dedicated window so Portainer has a stable title and workspace rule.
  - command: >-
      /usr/bin/librewolf --new-window
      https://portainer.creativetech.me/
    workspace: 2
    match:
      class: librewolf
      title: "Portainer"
'''

updated, count = pattern.subn(replacement, source, count=1)

if count != 1:
    raise SystemExit(
        "ERROR: Expected Workspace 2 browser block was not found exactly once. "
        "No changes made."
    )

if updated.count("https://portainer.creativetech.me/") != 1:
    raise SystemExit("ERROR: Validation failed: expected exactly one Portainer URL.")

try:
    import yaml
except ImportError:
    pass
else:
    yaml.safe_load(updated)

backup = profile.with_name(
    f"{profile.name}.{datetime.now().strftime('%Y%m%d-%H%M%S')}.bak"
)
shutil.copy2(profile, backup)

tmp = profile.with_suffix(".yaml.tmp")
tmp.write_text(updated, encoding="utf-8")
tmp.replace(profile)

print(f"Updated: {profile}")
print(f"Backup:  {backup}")
