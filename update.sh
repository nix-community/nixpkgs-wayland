#!/usr/bin/env bash
set -euo pipefail
set -x

cachixremote="nixpkgs-wayland"

# keep track of what we build and only upload at the end
pkgentries=()

function update() {
  attr="${1}"
  owner="${2}"
  repo="${3}"
  ref="${4}"

  rev=""
  url="https://api.github.com/repos/${owner}/${repo}/commits?sha=${ref}"
  rev="$(git ls-remote "https://github.com/${owner}/${repo}" "${ref}" | cut -d '	' -f1)"
  [[ -f "./${attr}/metadata.nix" ]] && oldrev="$(nix eval -f "./${attr}/metadata.nix" rev --raw)"
  if [[ "${oldrev:-}" != "${rev}" ]]; then
    revdata="$(curl -L --fail "https://api.github.com/repos/${owner}/${repo}/commits/${rev}")"
    revdate="$(echo "${revdata}" | jq -r ".commit.committer.date")"
    sha256="$(nix-prefetch-url --unpack "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz" 2>/dev/null)"
    printf '{\n  rev = "%s";\n  sha256 = "%s";\n  revdate = "%s";\n}\n' \
      "${rev}" "${sha256}" "${revdate}" > "./${attr}/metadata.nix"
    echo "${attr}" was updated to "${rev}" "${revdate}"
  fi

  commitdate="$(nix eval -f "./${attr}/metadata.nix" revdate --raw)"
  d="$(date '+%Y-%m-%d %H:%M' --date="${commitdate}")"
  txt="| ${attr} | [${d}](https://github.com/${owner}/${repo}/commits/${rev}) |"
  pkgentries=("${pkgentries[@]}" "${txt}")
}


# update <attr_name> <repo_owner> <repo_name> <repo_rev>
update "nixpkgs/nixos-unstable" "nixos" "nixpkgs-channels" "nixos-unstable"
update "nixpkgs/nixpkgs-unstable" "nixos" "nixpkgs-channels" "nixpkgs-unstable"

update "pkgs/fmt"              "fmtlib"     "fmt"              "master"

update "pkgs/wlroots"          "swaywm"     "wlroots"          "master"
update "pkgs/sway-beta"        "swaywm"     "sway"             "master"
update "pkgs/slurp"            "emersion"   "slurp"            "master"
update "pkgs/grim"             "emersion"   "grim"             "master"
update "pkgs/mako"             "emersion"   "mako"             "master"
update "pkgs/kanshi"           "emersion"   "kanshi"           "master"
update "pkgs/wlstream"         "atomnuker"  "wlstream"         "master"
update "pkgs/oguri"            "vilhalmer"  "oguri"            "master"
update "pkgs/waybar"           "Alexays"    "waybar"           "master"
update "pkgs/wayfire"          "WayfireWM"  "wayfire"          "master"
update "pkgs/wf-config"        "WayfireWM"  "wf-config"        "master"
update "pkgs/redshift-wayland" "minus7"     "redshift"         "wayland"
update "pkgs/bspwc"            "Bl4ckb0ne"  "bspwc"            "master"
update "pkgs/waybox"           "wizbright"  "waybox"           "master"
update "pkgs/wl-clipboard"     "bugaevc"    "wl-clipboard"     "master"

# i3-related
update "pkgs/wmfocus"          "svenstaro"  "wmfocus"          "master"
update "pkgs/i3status-rust"    "greshake"   "i3status-rust"    "master"

# update README.md
set +x
replace="$(printf "<!--pkgs-->")"
replace="$(printf "%s\n| Attribute Name | Last Upstream Commit Time |" "${replace}")"
replace="$(printf "%s\n| -------------- | ------------------------- |" "${replace}")"
for p in "${pkgentries[@]}"; do
  replace="$(printf "%s\n%s\n" "${replace}" "${p}")"
done
replace="$(printf "%s\n<!--pkgs-->" "${replace}")"
set -x

rg --multiline '(?s)(.*)<!--pkgs-->(.*)<!--pkgs-->(.*)' "README.md" \
  --replace "\$1${replace}\$3" \
    > README2.md; mv README2.md README.md

# build all and push to cachix
nix-build --no-out-link --keep-going build.nix | cachix push "${cachixremote}"
nix-build --no-out-link --keep-going build.nixpkgs.nix | cachix push "${cachixremote}"

