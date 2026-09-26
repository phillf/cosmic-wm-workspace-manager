"""Generic, non-mutating core for COSMIC Workspace Steward."""

from .xdg import ArtifactRoots, resolve_artifact_roots
from .yaml_io import load_yaml_mapping

__all__ = [
    "ArtifactRoots",
    "load_yaml_mapping",
    "resolve_artifact_roots",
]
