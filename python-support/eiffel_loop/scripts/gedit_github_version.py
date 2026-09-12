#!/usr/bin/env python3
"""
gedit_github_version.py

Given a source path under $HOME that contains a 'library' step, e.g.

    /home/finnian/Dev/Eiffel/library/Xpact-core/library/source/structures/declaration/xt_declaration_parts_list.e

this collapses everything from the first path component after $HOME up to
and including the first 'library' step into a single 'github' step:

    $HOME/github/Xpact-core/library/source/structures/declaration/xt_declaration_parts_list.e

If the resulting path exists, it is opened with gedit. Otherwise a message
is printed.
"""

import subprocess
import sys
from pathlib import Path


def github_version(src: Path) -> Path:
    home = Path.home()

    try:
        rel = src.relative_to(home)
    except ValueError:
        raise ValueError(f"path is not under home directory ({home}): {src}")

    parts = rel.parts

    if "library" not in parts:
        raise ValueError(f"no 'library' step found in path: {src}")

    idx = parts.index("library")  # first occurrence after $HOME
    remainder = parts[idx + 1:]

    return home.joinpath("github", *remainder)


def main() -> None:
    if len(sys.argv) != 2:
        print("Usage: gedit_github_version <path>")
        sys.exit(1)

    src = Path(sys.argv[1]).expanduser()

    try:
        new_path = github_version(src)
    except ValueError as e:
        print(f"Error: {e}")
        sys.exit(1)

    if not new_path.exists():
        print(f"File does not exist: {new_path}")
        sys.exit(1)

    subprocess.run(["gedit", str(new_path)])


if __name__ == "__main__":
    main()
