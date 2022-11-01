#!/usr/bin/env nix-shell
#! nix-shell -p python3 -i python3
# vim:ft=python
"""
usage: ./refresh_readme.py
"""

import json
import subprocess
from pathlib import Path


def get_attrs(system: str) -> dict[str, str]:
    """get_attrs"""
    attrs = (
        subprocess.check_output(
            ["nix", "eval", "--json", "--impure", f".#packages.{system}"]
        )
        .decode()
        .strip()
    )

    return json.loads(attrs)


def get_meta(attr: str, system: str) -> dict[str, str]:
    """get_meta"""
    attrs = (
        subprocess.check_output(
            ["nix", "eval", "--json", "--impure", f".#packages.{system}.{attr}.meta"]
        )
        .decode()
        .strip()
    )

    return json.loads(attrs)


def replace_pkg_lines(attrs: dict[str, str], system: str) -> None:
    """replace_pkg_lines"""
    readme = Path("./README.md")
    readme_text = readme.read_text(encoding="UTF-8").splitlines()
    readme_tmp = Path("./README.md.tmp")
    flag = 0
    written = 0
    with readme_tmp.open("w", encoding="UTF-8") as out:
        for line in readme_text:
            if line.startswith("<!--pkgs-->"):
                if flag:
                    print("end")
                    flag = 0
                else:
                    print("start")
                    flag = 1

            if flag and not line.startswith("<!--pkgs-->"):
                if not written:
                    out.write("| Package | Description |\n")
                    out.write("| --- | --- |\n")
                    for key in attrs.keys():
                        if key == "default":
                            continue
                        meta = get_meta(key, system)
                        out.write(
                            f"| [{key}]({meta.get('homepage')}) | {meta.get('description')} |"
                        )
                        out.write("\n")
                        written = 1
                continue

            out.write(line)
            out.write("\n")

    readme_tmp.replace(readme)


def main() -> None:
    """main"""

    system = (
        subprocess.check_output(
            ["nix", "eval", "--raw", "--impure", "--expr", "builtins.currentSystem"]
        )
        .decode()
        .strip()
    )

    attrs = get_attrs(system)

    replace_pkg_lines(attrs, system)


if __name__ == "__main__":
    main()
