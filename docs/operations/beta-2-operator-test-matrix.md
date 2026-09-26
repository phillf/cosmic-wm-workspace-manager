# Beta 2 Operator Test Matrix

## Status and safety boundary

This matrix covers the **currently implemented generic, read-only core** of
COSMIC Workspace Steward.

It does not validate, invoke, configure, or replace the CT-specific reference
deployment documented elsewhere in this repository. In particular, these tests
do not run `ws-man`, `cosmic-wm`, bootstrap, profile synchronization, live
reroute, browser launch, or desktop restoration commands.

Run these checks in a non-production shell session. They are intended to inspect
the repository checkout and generic Python package only.

## Implemented generic capabilities

The current generic package provides:

- Read-only resolution of user-owned XDG config, state, and data roots.
- Expansion of `~` in explicit XDG root overrides.
- Rejection of relative XDG root overrides.
- Safe loading of an existing regular YAML file as a non-empty mapping.
- Rejection of malformed YAML, unsafe YAML tags, non-mapping documents, and
  missing or non-regular artifact paths.

The generic root resolver does not create directories. The YAML loader does not
write files or execute YAML-provided code.

## Planned, not executable

The following generic design capabilities are not implemented in this Beta 2
slice and must not be represented as available commands:

- `ws-man doctor`
- Generic profile or session discovery
- Generic `profiles list`, `sessions list`, or `show` commands
- COSMIC adapter capability probing
- Generic `start --dry-run` or `restore --dry-run` planning
- Generic import drafts, promotion, migration, backup, apply, or restore
- Generic installation, autostart, or desktop mutation

The existing CT-specific `ws-man` and `cosmic-wm` workflows remain separately
documented operational behavior. They are not generic Beta 2 capabilities.

## Test matrix

| Check | Command | Expected pass condition | Failure condition | Mutation |
|---|---|---|---|---|
| Confirm checkout identity | `git status -sb` | The intended branch and repository are displayed; no unexpected changes are present | Unexpected modified, staged, or untracked files require review before testing | None |
| Run generic core tests | `.venv/bin/python -m pytest -q` | All collected tests pass | Any failed or errored test requires investigation; unexpected skips require review | None |
| Compile package and tests | `.venv/bin/python -m compileall -q src tests` | Command exits with status 0 and prints no errors | Any syntax or import compilation error | Writes Python bytecode only; normally ignored by Git |
| Review test collection | `.venv/bin/python -m pytest --collect-only -q` | The current suite collects the XDG and YAML safety tests | Missing or unexpected collection requires review | None |
| Inspect resolved default roots | See [XDG root check](#xdg-root-check) | Three paths are printed; their leaf directories do not need to exist | Relative or invalid root configuration, or unexpected directory creation | None |
| Validate a copied YAML artifact | See [YAML loader check](#yaml-loader-check) | A simple mapping prints as a Python dictionary | Loader accepts unsafe YAML, non-mapping YAML, or nonexistent paths | Creates only a temporary file under `/tmp` |

## Standard non-production validation

From the repository root:

```bash
set -Eeuo pipefail

REPO="/home/pjfernandes/Projects/ct/cosmic-wm-workspace-steward"
VENV="$REPO/.venv"

cd "$REPO"

git status -sb
"$VENV/bin/python" -m compileall -q src tests
"$VENV/bin/python" -m pytest -q
"$VENV/bin/python" -m pytest --collect-only -q
```

Pass criteria:

- `git status -sb` shows only the changes you intentionally made, or a clean
  working tree.
- Compilation exits successfully.
- Every collected test passes.
- The test collection contains XDG root and safe YAML loader coverage.

This procedure does not call `ws-man` or `cosmic-wm`, and it does not modify
desktop state.

## XDG root check

Run this from the repository root:

```bash
set -Eeuo pipefail

.venv/bin/python - <<'PY'
from os import environ
from pathlib import Path

from cosmic_workspace_steward import resolve_artifact_roots

roots = resolve_artifact_roots(environ, Path.home())
print(f"config={roots.config}")
print(f"state={roots.state}")
print(f"data={roots.data}")
print(f"config_exists={roots.config.exists()}")
print(f"state_exists={roots.state.exists()}")
print(f"data_exists={roots.data.exists()}")
PY
```

Expected output uses the current user's XDG defaults unless overrides are set:

```text
config=/home/USER/.config/cosmic-workspace-steward
state=/home/USER/.local/state/cosmic-workspace-steward
data=/home/USER/.local/share/cosmic-workspace-steward
```

The `*_exists` lines may be either `True` or `False`. The resolver itself must
not create those directories.

To test explicit roots without touching the real user roots:

```bash
set -Eeuo pipefail

TMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_ROOT"' EXIT

.venv/bin/python - "$TMP_ROOT" <<'PY'
import sys
from pathlib import Path

from cosmic_workspace_steward import resolve_artifact_roots

tmp_root = Path(sys.argv[1])
roots = resolve_artifact_roots(
    {
        "XDG_CONFIG_HOME": str(tmp_root / "config"),
        "XDG_STATE_HOME": str(tmp_root / "state"),
        "XDG_DATA_HOME": str(tmp_root / "data"),
    },
    Path.home(),
)
print(roots)
assert not roots.config.exists()
assert not roots.state.exists()
assert not roots.data.exists()
PY
```

Pass criteria: the command exits successfully and the three asserted directories
remain absent.

## YAML loader check

This check uses a temporary file and does not write any configured artifact root:

```bash
set -Eeuo pipefail

TMP_YAML="$(mktemp)"
trap 'rm -f "$TMP_YAML"' EXIT

cat > "$TMP_YAML" <<'YAML'
version: 1
kind: profile
name: example
YAML

TMP_YAML="$TMP_YAML" .venv/bin/python - <<'PY'
import os
from pathlib import Path

from cosmic_workspace_steward import load_yaml_mapping

artifact = load_yaml_mapping(Path(os.environ["TMP_YAML"]))
assert artifact == {
    "version": 1,
    "kind": "profile",
    "name": "example",
}
print("PASS: safe YAML mapping loaded")
PY
```

Expected output:

```text
PASS: safe YAML mapping loaded
```

The following unsafe construct must fail rather than execute:

```bash
set -Eeuo pipefail

TMP_YAML="$(mktemp)"
trap 'rm -f "$TMP_YAML"' EXIT

cat > "$TMP_YAML" <<'YAML'
value: !!python/object/apply:os.system ["echo unsafe"]
YAML

TMP_YAML="$TMP_YAML" .venv/bin/python - <<'PY'
import os
from pathlib import Path

from cosmic_workspace_steward import load_yaml_mapping
from cosmic_workspace_steward.errors import YamlArtifactError

try:
    load_yaml_mapping(Path(os.environ["TMP_YAML"]))
except YamlArtifactError as error:
    print(f"PASS: unsafe YAML rejected: {error}")
else:
    raise SystemExit("FAIL: unsafe YAML was accepted")
PY
```

Pass criteria: output begins with `PASS: unsafe YAML rejected:` and the string
`unsafe` is not emitted as a command result.

## `ws-man doctor` collection

Generic `ws-man doctor` is planned but is not implemented in this repository at
this time. Do not substitute the CT-specific `ws-man status` command for generic
doctor output, and do not claim that a generic adapter capability report exists.

When generic doctor is implemented, this matrix must be updated with:

- The exact read-only command.
- Expected environment, XDG-root, validation, and adapter-capability output.
- Warning versus blocker behavior.
- Expected exit statuses.
- Proof that the command creates no artifact files and makes no desktop changes.

## Limitations and recovery

Passing these checks does not prove or provide:

- Profile/session discovery or artifact schema-envelope validation beyond the
  currently tested YAML mapping boundary.
- COSMIC workspace creation, window movement, or native capability detection.
- Generic profile/session application, restoration, import, promotion, backup,
  migration, or rollback.
- Geometry, tile ordering, focus, stack/tab groups, monitor layout, or browser
  state restoration.
- Browser page, tab, session, authentication, or placement restoration.

The current generic checks are read-only, apart from temporary test files and
normally ignored Python bytecode. They create no generic artifacts and make no
desktop changes, so they have no generic rollback procedure.

For CT-specific recovery and live operational behavior, use the established
[recovery procedure](recovery.md). Do not use generic Beta 2 validation as a
replacement for CT operational validation.
