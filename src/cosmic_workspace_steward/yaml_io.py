"""Safe, read-only YAML mapping loading."""

from __future__ import annotations

from pathlib import Path
from typing import Any

import yaml

from .errors import YamlArtifactError


def load_yaml_mapping(path: Path) -> dict[str, Any]:
    """Safely load one non-empty YAML mapping from an existing regular file."""

    artifact_path = Path(path)

    if not artifact_path.is_file():
        raise YamlArtifactError(artifact_path, "artifact is not an existing regular file")

    try:
        with artifact_path.open(encoding="utf-8") as stream:
            document = yaml.safe_load(stream)
    except OSError as exc:
        raise YamlArtifactError(artifact_path, f"unable to read artifact: {exc.strerror}") from exc
    except yaml.YAMLError as exc:
        raise YamlArtifactError(artifact_path, f"invalid or unsafe YAML: {exc}") from exc

    if document is None:
        raise YamlArtifactError(artifact_path, "artifact is empty")

    if not isinstance(document, dict):
        raise YamlArtifactError(artifact_path, "artifact root must be a YAML mapping")

    return document
