#!/usr/bin/env python3
"""Install the bundled Codex skill; no downloads or third-party packages."""
import argparse
import os
from pathlib import Path
import shutil
import sys
import tempfile
import uuid

NAME = "linkedin-content-writer"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--skills-dir", type=Path, help="Override the destination skills directory")
    parser.add_argument("--replace", action="store_true", help="Back up an existing installation before replacing it")
    parser.add_argument("--dry-run", action="store_true", help="Show paths without changing files")
    args = parser.parse_args()
    source = Path(__file__).resolve().parent / "skills" / NAME
    codex_home = Path(os.environ.get("CODEX_HOME") or Path.home() / ".codex").expanduser()
    root = (args.skills_dir or codex_home / "skills").expanduser().resolve()
    target = root / NAME
    if not (source / "SKILL.md").is_file():
        parser.error("Bundled SKILL.md is missing; use the complete repository.")
    if target.is_symlink():
        parser.error("Destination is a symbolic link; choose a different skills directory.")
    if target == source or source in target.parents or target in source.parents:
        parser.error("Destination overlaps the source repository.")
    if target.exists() and not args.replace:
        parser.error(f"Already installed at {target}. Use --replace to preserve a backup and update.")
    if args.dry_run:
        print(f"Would install {source} -> {target}")
        return
    root.mkdir(parents=True, exist_ok=True)
    backup = None
    # Stage the complete copy before moving the existing installation.
    with tempfile.TemporaryDirectory(prefix=".linkedin-install-", dir=root) as temporary:
        staged = Path(temporary) / NAME
        shutil.copytree(source, staged)
        if target.exists():
            backup = root / f"{NAME}.backup-{uuid.uuid4().hex}"
            target.rename(backup)
        try:
            staged.rename(target)
        except OSError:
            if backup is not None:
                backup.rename(target)
            raise
    print(f"Installed: {target}")
    if backup is not None:
        print(f"Backup: {backup}")
    print("Start a new Codex session, then invoke $linkedin-content-writer.")


if __name__ == "__main__":
    try:
        main()
    except OSError as error:
        print(f"Installation failed: {error}", file=sys.stderr)
        sys.exit(1)
