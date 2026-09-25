# COSMIC Workspace Steward Design

## Status

**Proposal / pre-implementation design.**

COSMIC Workspace Steward is a YAML-driven workspace profile and session stewardship tool for COSMIC Desktop. Its operator-facing command is `ws-man`.

It is not a window manager or compositor. It delegates native workspace and window operations to the installed `cosmic-wm` command.

> Unofficial community tooling. COSMIC Workspace Steward is not affiliated with, endorsed by, or maintained by System76 or the COSMIC Desktop project.

## Goals

- Support user-defined workspace arrangements without hard-coded role, application, browser, session, or workspace-count assumptions.
- Discover profiles and sessions from configured YAML directories.
- Provide safe status, validation, dry-run, import-draft, backup, migration, and restore workflows.
- Keep desktop behavior policy in YAML data rather than executable constants.
- Preserve compatibility with existing deployments during migration.

## YAML-only persistence

**All persisted `ws-man` configuration, session, profile, template, import-draft, backup manifest, and migration-map artifacts use YAML. JSON is not a supported persisted `ws-man` format.**

An upstream/native tool may provide machine-readable output at runtime. If consumed, COSMIC Workspace Steward normalizes the result into YAML before writing any persistent artifact.

## Generic command model

```text
ws-man doctor
ws-man status
ws-man profiles list
ws-man sessions list
ws-man show profile NAME
ws-man show session NAME
ws-man init --dry-run
ws-man import --name NAME --dry-run
ws-man start PROFILE --dry-run
ws-man restore SESSION --dry-run
ws-man promote DRAFT --as profile|session --dry-run
ws-man migrate --from PATH --dry-run
```

The generic tool must not encode a default role name, fixed workspace range, fixed protected workspace, specific applications, browser exclusions, or a hard-coded session name. Those are user-defined YAML policy.

## Naming and scope

```text
Product:     COSMIC Workspace Steward
CLI:         ws-man
Repository:  cosmic-workspace-steward (target identity)
```

`cosmic-wm` remains the native workspace/window engine. COSMIC Workspace Steward owns higher-level discovery, validation, YAML artifacts, safety policy, import, migration, preview, and orchestration.

## XDG layout

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

These are target paths for the generic implementation. They do not imply that an existing deployment has been migrated.

## Safety model

- Read-only commands must not change windows or files.
- State-changing commands must provide `--dry-run` where meaningful.
- Import creates review-required YAML drafts and never activates them automatically.
- Existing artifacts are never overwritten without an explicit replace action, backup, and confirmation.
- Dependency installation and autostart are separate opt-in operations.
- The generic core never invokes `sudo` or installs packages silently.
- Native limitations must be disclosed before applying a profile or session.
- Application/browser/workspace inclusion and exclusion are YAML policy, not product-wide assumptions.

## Migration approach

Existing project-specific scripts, profiles, sessions, symlinks, remote configuration, and bootstrap behavior remain unchanged during the design and branding phase.

A later migration command will inspect legacy YAML and produce a review-required YAML migration map. It will not delete, replace, activate, or disable legacy assets automatically.
