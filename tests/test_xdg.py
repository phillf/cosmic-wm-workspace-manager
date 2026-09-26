from pathlib import Path

import pytest

from cosmic_workspace_steward.xdg import APPLICATION_DIRECTORY, resolve_artifact_roots


def test_resolves_default_xdg_roots_without_creating_directories(tmp_path: Path) -> None:
    home = tmp_path / "home"
    roots = resolve_artifact_roots({}, home)

    assert roots.config == home / ".config" / APPLICATION_DIRECTORY
    assert roots.state == home / ".local" / "state" / APPLICATION_DIRECTORY
    assert roots.data == home / ".local" / "share" / APPLICATION_DIRECTORY
    assert not roots.config.exists()
    assert not roots.state.exists()
    assert not roots.data.exists()


def test_resolves_xdg_environment_overrides(tmp_path: Path) -> None:
    environment = {
        "XDG_CONFIG_HOME": str(tmp_path / "custom-config"),
        "XDG_STATE_HOME": str(tmp_path / "custom-state"),
        "XDG_DATA_HOME": str(tmp_path / "custom-data"),
    }

    roots = resolve_artifact_roots(environment, tmp_path / "home")

    assert roots.config == tmp_path / "custom-config" / APPLICATION_DIRECTORY
    assert roots.state == tmp_path / "custom-state" / APPLICATION_DIRECTORY
    assert roots.data == tmp_path / "custom-data" / APPLICATION_DIRECTORY

def test_expands_home_in_xdg_override(tmp_path: Path) -> None:
    home = tmp_path / "home"

    roots = resolve_artifact_roots(
        {"XDG_CONFIG_HOME": "~/custom-config"},
        home,
    )

    assert roots.config == home / "custom-config" / APPLICATION_DIRECTORY


def test_rejects_relative_xdg_override(tmp_path: Path) -> None:
    from cosmic_workspace_steward.errors import ArtifactError

    with pytest.raises(
        ArtifactError,
        match="XDG_CONFIG_HOME must be an absolute path when set",
    ):
        resolve_artifact_roots(
            {"XDG_CONFIG_HOME": "relative-config"},
            tmp_path / "home",
        )
