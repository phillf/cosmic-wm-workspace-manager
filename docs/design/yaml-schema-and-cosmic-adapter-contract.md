# YAML Schema and COSMIC Adapter Contract

## Status

**Proposal / pre-implementation design.**

This document defines the versioned YAML artifact contract and the COSMIC adapter
boundary for the future generic COSMIC Workspace Steward implementation. It does
not change the current CT-specific reference deployment, its `sysadmin` profiles,
its `sysadmin-live-reroute` session, or the behavior of the current `ws-man`
wrapper.

The generic core owns user-facing YAML artifacts, validation, discovery, safety
policy, backup/migration metadata, and command planning. The COSMIC adapter owns
translation to installed native `cosmic-wm` capabilities.

## Normative language

The key words **MUST**, **MUST NOT**, **REQUIRED**, **SHOULD**, **SHOULD NOT**, and
**MAY** are used as normative requirements.

## Persistence policy

**All persisted COSMIC Workspace Steward configuration, profile, session,
template, import-draft, backup-manifest, and migration-map artifacts use YAML.
JSON is not a supported persisted COSMIC Workspace Steward format.**

An installed native command MAY emit JSON or another machine-readable format at
runtime. The adapter MAY consume that output, but any Workspace Steward artifact
written to disk MUST be YAML.

YAML parsers MUST use safe loading behavior. Implementations MUST NOT construct
arbitrary language objects, execute YAML tags, or evaluate embedded code.

## Artifact roots

Generic artifacts follow XDG base directories:

```text
${XDG_CONFIG_HOME:-$HOME/.config}/cosmic-workspace-steward/
  config.yaml
  profiles/
  sessions/
  templates/

${XDG_STATE_HOME:-$HOME/.local/state}/cosmic-workspace-steward/
  backups/
  imports/
  migrations/
  logs/

${XDG_DATA_HOME:-$HOME/.local/share}/cosmic-workspace-steward/
  examples/
```

The generic core MUST treat these as user-owned artifact roots. The adapter MAY
have separately configured targets for native COSMIC assets:

```yaml
version: 1
kind: config

paths:
  cosmic_profiles: ~/.config/cosmic-wm-manager/profiles
  cosmic_sessions: ~/.config/cosmic-wm-manager/sessions
```

The generic core MUST NOT hard-code a current deployment path, profile family,
workspace count, session name, browser rule, or protected workspace.

## Common document envelope

Every persisted artifact MUST be a single YAML mapping and include:

```yaml
version: 1
kind: profile
name: example-name
```

Required common fields:

| Field | Type | Requirement |
|---|---|---|
| `version` | integer | MUST be supported by the implementation; initial version is `1` |
| `kind` | string | MUST match the expected artifact kind |
| `name` | string | MUST equal the filename-derived logical name where applicable |

Allowed initial `kind` values:

```text
config
profile
session
template
import-draft
backup-manifest
migration-map
```

Unknown top-level fields SHOULD be rejected by default until a forward-compatible
extension policy is defined. This prevents silently ignoring misspelled safety
settings.

## Safe logical names and paths

Logical names for profiles, sessions, templates, aliases, import drafts, and
migration artifacts MUST match:

```text
^[A-Za-z0-9][A-Za-z0-9._-]{0,63}$
```

Names MUST NOT contain `/`, `\`, `..`, NUL, shell expansion syntax, or whitespace.
Commands MUST accept logical names, not arbitrary paths.

For a profile named `development`, discovery resolves only:

```text
<configured-profile-root>/development.yaml
<configured-profile-root>/development.yml
```

Rules:

- Exactly one supported extension MAY exist for a logical name.
- Simultaneous `.yaml` and `.yml` files for one logical name are an ambiguity and
  MUST fail discovery.
- A discovered artifact MUST be a regular file or a symlink that resolves inside
  its configured root.
- Symlinks resolving outside the configured root MUST be rejected.
- The internal YAML `name` MUST equal the filename-derived logical name.
- The document `kind` MUST match the directory/command context.
- User-provided names MUST never be concatenated into shell commands.

## Global configuration schema

`config.yaml` stores generic user defaults and adapter targets.

```yaml
version: 1
kind: config
name: default

paths:
  cosmic_profiles: ~/.config/cosmic-wm-manager/profiles
  cosmic_sessions: ~/.config/cosmic-wm-manager/sessions

defaults:
  timeout_seconds: 30
  backup_before_write: true
  require_confirmation_for_apply: true
  require_dry_run_before_apply: false

import:
  exclude_browsers_by_default: true
  create_draft_only: true
  status_source_preference:
    - native_machine_readable
    - native_human_readable_best_effort

aliases: {}
```

Validation requirements:

- `timeout_seconds` MUST be a positive number.
- Boolean fields MUST be YAML booleans.
- Paths MAY contain `~` and environment-variable notation in source YAML, but
  MUST be expanded and canonicalized before use.
- Adapter target paths MUST be validated for containment/writability before an
  operation that writes native assets.
- Aliases MUST map safe logical alias names to safe discovered logical names.
- Aliases MUST NOT bypass profile/session discovery or path validation.

## Profile schema

A profile describes a planned application/workspace configuration. It is distinct
from a session because a profile MAY support application launch only when that
behavior is explicitly permitted.

```yaml
version: 1
kind: profile
name: development
description: Development workspace profile.

default_timeout_seconds: 180

workspaces:
  - id: 1
    applications:
      - app_id: org.example.Terminal
        match:
          class: org.example.Terminal
  - id: 4
    applications:
      - app_id: code
        match:
          class: code

safety:
  launch_missing_applications: true
  move_browser_windows: false
```

Requirements:

- `workspaces` MUST be an explicit list; absence does not mean all workspaces.
- Workspace identifiers are profile data, not globally bounded constants.
- The adapter MUST reject unsupported workspace identifiers for the native target.
- `launch_missing_applications` defaults to `false` if omitted.
- Browser-moving behavior defaults to `false` if omitted.
- A profile MUST describe only behavior the adapter can render or enforce.

## Session schema

A session describes existing-window matching and restoration policy. Sessions
default to non-launching behavior.

```yaml
version: 1
kind: session
name: native-reroute
description: Route matching already-open native windows.

mode: existing-windows-only
default_timeout_seconds: 30

scope:
  include_workspaces:
    - 1
    - 2
    - 3
  exclude_workspaces:
    - 8

matching:
  include_app_ids:
    - Spotify
    - code
  exclude_app_ids:
    - librewolf

safety:
  launch_missing_applications: false
  move_browser_windows: false
  restore_geometry: false
  restore_tiling_order: false
  require_dry_run_before_apply: true
```

Requirements:

- `mode` MUST initially be either `existing-windows-only` or
  `launch-missing-applications`.
- `existing-windows-only` MUST NOT launch missing applications.
- An empty `include_workspaces` MUST NOT silently mean every workspace; the
  session must have another explicit adapter-supported scope rule.
- `include_workspaces` and `exclude_workspaces` MUST NOT overlap.
- `include_app_ids` and `exclude_app_ids` MUST NOT overlap.
- Browser movement defaults to disabled.
- Geometry, tiling order, focus, tab/stack layout, browser state, and browser
  page identity MUST default to disabled and MUST NOT be claimed as restored
  unless native capability is detected and explicitly enabled.
- A session requiring a dry run MUST reject direct apply until an equivalent
  successful dry run is recorded or explicitly acknowledged by the operator.

## Application matching model

The initial generic matching precedence is:

1. Stable application ID.
2. Stable class/app class.
3. Exact title.
4. Explicit regular expression only if a later schema version defines safe,
   bounded regular-expression semantics.

Broad substring matching MUST NOT be an implicit default.

A match rule MUST use at least one adapter-supported criterion. If multiple
criteria are present, all criteria MUST match unless the schema explicitly
introduces an alternate boolean expression model.

Browser windows SHOULD be excluded by default during import. Changing browser
policy MUST be explicit in the saved YAML artifact.

## Import-draft schema

Import produces a review-required draft. It does not activate, install, render,
or apply the observed layout.

```yaml
version: 1
kind: import-draft
name: current-layout
created_at: 2026-09-25T18:57:00-04:00

source:
  command: cosmic-wm status
  format: native_machine_readable
  adapter_version: 1

review_required: true
activation_state: draft

observed_windows:
  - app_id: Spotify
    title: Example title
    workspace: 1

proposed_policy:
  mode: existing-windows-only
  default_timeout_seconds: 30
  excluded_app_ids:
    - librewolf
  protected_workspaces: []

notes:
  - Review inferred identifiers and workspace assignments before promotion.
```

Requirements:

- A draft MUST identify its source and source format.
- `format` MUST distinguish stable machine-readable data from
  `native_human_readable_best_effort`.
- Best-effort parsing MUST be visibly labeled in the draft and command output.
- A draft MUST remain `review_required: true` until explicit promotion.
- Import MUST create a new artifact and MUST NOT overwrite an existing draft.
- Import MUST NOT change windows, launch applications, enable autostart, or
  install a generated profile/session.

## Backup-manifest schema

```yaml
version: 1
kind: backup-manifest
name: promote-current-layout
created_at: 2026-09-25T18:57:00-04:00
reason: Promote import draft as session.
entries:
  - source: ~/.config/cosmic-workspace-steward/sessions/morning-layout.yaml
    backup: ~/.local/state/cosmic-workspace-steward/backups/2026-09-25T185700/sessions/morning-layout.yaml
    checksum: sha256:REPLACE_AT_WRITE_TIME
```

Requirements:

- A backup manifest MUST be written when a confirmed replace operation backs up
  an existing artifact.
- Backup paths MUST resolve under the state backup root.
- Checksums SHOULD use SHA-256 and MUST be calculated from the persisted backup.
- The manifest MUST record the reason and timestamp.

## Migration-map schema

```yaml
version: 1
kind: migration-map
name: ct-reference-assessment
created_at: 2026-09-25T18:57:00-04:00
source_root: /path/to/legacy-repository
review_required: true

mappings:
  - legacy_path: profiles/example.yaml
    target_kind: profile
    proposed_name: example
    action: copy-as-draft

unmapped:
  - legacy_path: scripts/legacy/example.sh
    reason: Executable legacy helper retained for audit and manual review.
```

Requirements:

- Migration MUST generate a map before copying or promoting artifacts.
- Migration MUST NOT delete, rewrite, activate, disable, or replace legacy assets
  automatically.
- Executable legacy helpers MUST be classified for manual review.
- Eligible YAML artifacts MUST be copied as drafts until explicit promotion.

## COSMIC adapter contract

The adapter is the only layer allowed to invoke `cosmic-wm`. The generic core
passes validated in-memory models and receives structured capability/result data.

Required operations:

```text
adapter.doctor()
adapter.status()
adapter.discover_capabilities()
adapter.render_profile(profile)
adapter.render_session(session)
adapter.plan_start(profile, timeout)
adapter.plan_restore(session, timeout, debug)
adapter.apply(plan)
adapter.import_status()
```

Adapter requirements:

- Build subprocess requests as argument arrays, never concatenated shell strings.
- Render dry-run commands with shell-safe quoting.
- Fail closed when a requested capability is not available.
- Report detected native command path, version, supported subcommands, and
  known limitations through `doctor`.
- Never parse human-oriented status output for a changing operation without
  creating a review-required import draft.
- Keep native file rendering separate from generic YAML persistence.
- Refuse to claim support for geometry/order/focus/browser restoration unless
  capability discovery confirms it and the user artifact enables it.

## Command planning and dry runs

The generic core distinguishes planning from application:

```text
ws-man start PROFILE --dry-run
ws-man restore SESSION --dry-run
```

A dry run MUST show:

- Resolved profile/session logical name.
- Source YAML artifact path.
- Default versus overridden timeout.
- Adapter capability assumptions.
- Native commands as safely quoted argument arrays.
- Native asset paths that would be written or read.
- Any policy exclusions, including excluded workspaces or applications.
- Any unmet precondition that would block apply.

A dry run MUST NOT:

- Move, launch, close, or focus windows.
- Write generic YAML artifacts.
- Write native COSMIC assets.
- Enable autostart.
- Install dependencies.
- Create backups.

## Apply safety and transaction rules

Commands that write artifacts or invoke native changing operations MUST:

1. Validate schema, names, paths, adapter capability, and policy.
2. Produce an equivalent dry-run plan unless the command is inherently read-only.
3. Require the configured confirmation policy before application.
4. Use a per-user lock to prevent concurrent apply/import/promote/migrate runs.
5. Use atomic temporary-file-and-rename writes where possible.
6. Back up existing artifacts before an explicit confirmed replacement when
   `backup_before_write` is enabled.
7. Produce a YAML backup manifest for replacement operations.
8. Leave original artifacts intact if a pre-apply validation fails.
9. Return non-zero and identify the failed stage on error.

No generic operation may invoke broad process termination as cleanup.

## Read-only discovery baseline

The first generic implementation milestone MUST provide these read-only commands:

```text
ws-man doctor
ws-man status
ws-man profiles list
ws-man sessions list
ws-man show profile NAME
ws-man show session NAME
```

Discovery MUST validate schema envelope, filename/name agreement, file containment,
and ambiguity before listing an artifact as usable.

The next milestone MAY add command planning only:

```text
ws-man start PROFILE --dry-run
ws-man restore SESSION --dry-run
```

Actual desktop-changing apply behavior comes only after discovery, schema
validation, dry-run rendering, capability checks, and safety controls are tested.

## CT reference-deployment boundary

The present repository contains a working CT-specific reference deployment. Its
current wrapper, profiles, session snapshot, bootstrap script, workspace policy,
browser exclusions, and operational procedures remain authoritative for that
deployment.

The generic contract defined here MUST NOT silently alter those current commands
or assets. During transition:

- Existing compatibility commands remain explicit and behavior-preserving.
- CT-specific YAML and scripts are migrated only through review-required drafts.
- The generic core contains no `sysadmin`, fixed WS1–WS6 range, WS7 policy,
  fixed browser exclusion, or fixed session-name constant.
- Reference deployment behavior is documented separately from generic user-facing
  behavior.
