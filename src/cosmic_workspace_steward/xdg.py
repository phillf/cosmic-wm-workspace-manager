"""Read-only XDG artifact-root resolution."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Mapping

from .errors import ArtifactError

APPLICATION_DIRECTORY = "cosmic-workspace-steward"


@dataclass(frozen=True)
class ArtifactRoots:
    """User-owned generic Workspace Steward artifact roots."""

    config: Path
    state: Path
    data: Path


def _environment_path(
    environment: Mapping[str, str],
    variable: str,
    default: Path,
    home: Path,
) -> Path:
    value = environment.get(variable)
    if not value:
        return default

    candidate = Path(value)
    if candidate == Path("~"):
        candidate = home
    elif candidate.parts and candidate.parts[0] == "~":
        candidate = home.joinpath(*candidate.parts[1:])

    if not candidate.is_absolute():
        raise ArtifactError(f"{variable} must be an absolute path when set")

    return candidate


def resolve_artifact_roots(
    environment: Mapping[str, str],
    home: Path,
) -> ArtifactRoots:
    """Resolve generic XDG artifact roots without creating directories."""

    expanded_home = home.expanduser()

    config_base = _environment_path(
        environment,
        "XDG_CONFIG_HOME",
        expanded_home / ".config",
        expanded_home,
    )
    state_base = _environment_path(
        environment,
        "XDG_STATE_HOME",
        expanded_home / ".local" / "state",
        expanded_home,
    )
    data_base = _environment_path(
        environment,
        "XDG_DATA_HOME",
        expanded_home / ".local" / "share",
        expanded_home,
    )

    return ArtifactRoots(
        config=config_base / APPLICATION_DIRECTORY,
        state=state_base / APPLICATION_DIRECTORY,
        data=data_base / APPLICATION_DIRECTORY,
    )
