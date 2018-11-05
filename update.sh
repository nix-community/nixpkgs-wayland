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

  if [[ "${attr}" == pkgs* ]]; then return; fi

  commitdate="$(nix eval -f "./${attr}/metadata.nix" revdate --raw)"
  d="$(date '+%Y-%m-%d %H:%M' --date="${commitdate}")"
  txt="| ${attr} | [${d}](https://github.com/${owner}/${repo}/commits/${rev}) |"
  pkgentries=("${pkgentries[@]}" "${txt}")
}


#      attr_name          repo_owner   repo_name          repo_rev
update "pkgs-unstable"    "nixos"      "nixpkgs-channels" "nixos-unstable"
update "pkgs-18.09"       "nixos"      "nixpkgs-channels" "nixos-18.09"

update "fmt"              "fmtlib"     "fmt"              "master"

update "wlroots"          "swaywm"     "wlroots"          "master"
update "sway-beta"        "swaywm"     "sway"             "master"
update "slurp"            "emersion"   "slurp"            "master"
update "grim"             "emersion"   "grim"             "master"
update "mako"             "emersion"   "mako"             "master"
update "kanshi"           "emersion"   "kanshi"           "master"
update "wlstream"         "atomnuker"  "wlstream"         "master"
update "oguri"            "vilhalmer"  "oguri"            "master"
update "waybar"           "Alexays"    "waybar"           "master"
update "wayfire"          "WayfireWM"  "wayfire"          "master"
update "wf-config"        "WayfireWM"  "wf-config"        "master"
update "redshift-wayland" "minus7"     "redshift"         "wayland"
update "bspwc"            "Bl4ckb0ne"  "bspwc"            "master"
update "waymonad"         "waymonad"   "waymonad"         "master"

# i3-related
update "wmfocus"          "svenstaro"  "wmfocus"          "master"
update "i3status-rust"    "greshake"   "i3status-rust"    "master"

# misc
update "ripasso"          "cortex"     "ripasso"          "master"

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

rg --multiline '(?s)(.*)<!--update-->(.*)<!--update-->(.*)' "README.md" \
  --replace "\$1<!--update-->$(date '+%Y-%m-%d %H:%M')<!--update-->\$3" \
    > README2.md; mv README2.md README.md

# build all and push to cachix
nix-build --no-out-link --keep-going build.nix | cachix push "${cachixremote}"

