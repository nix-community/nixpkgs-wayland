#!/usr/bin/env bash
set -euo pipefail
set -x

cachixremote="nixpkgs-wayland"

# keep track of what we build and only upload at the end
pkgentries=()

# keep track of manuals to output at the end
manuals=()

function manual() {
  manuals=("${manuals[@]}" "${1}")
}

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
  d="$(date -u '+%Y-%m-%d %H:%M' --date="${commitdate}")"
  txt="| ${attr} | [${d}](https://github.com/${owner}/${repo}/commits/${rev}) |"
  pkgentries=("${pkgentries[@]}" "${txt}")
}


# update <attr_name> <repo_owner> <repo_name> <repo_rev>
update "nixpkgs/nixos-unstable" "nixos" "nixpkgs-channels" "nixos-unstable"
update "nixpkgs/nixpkgs-unstable" "nixos" "nixpkgs-channels" "nixpkgs-unstable"

manual "pkgs/bspwc"
update "pkgs/cage"             "Hjdskes" "cage" "master"
update "pkgs/dot-desktop"      "kennylevinsen" "dot-desktop"   "master"
update "pkgs/gebaar-libinput"  "Coffee2CodeNL" "gebaar-libinput" "master"
manual "pkgs/glpaper"
update "pkgs/grim"             "emersion"   "grim"             "master"
update "pkgs/i3status-rust"    "greshake"   "i3status-rust"    "master"
update "pkgs/kanshi"           "emersion"   "kanshi"           "master"
update "pkgs/mako"             "emersion"   "mako"             "master"
update "pkgs/oguri"            "vilhalmer"  "oguri"            "master"
update "pkgs/redshift-wayland" "minus7"     "redshift"         "wayland"
update "pkgs/slurp"            "emersion"   "slurp"            "master"
update "pkgs/sway"             "swaywm"     "sway"             "master"
update "pkgs/swaybg"           "swaywm"     "swaybg"           "master"
update "pkgs/swayidle"         "swaywm"     "swayidle"         "master"
update "pkgs/swaylock"         "swaywm"     "swaylock"         "master"
update "pkgs/waybar"           "Alexays"    "waybar"           "master"
update "pkgs/waybox"           "wizbright"  "waybox"           "master"
update "pkgs/wayfire"          "WayfireWM"  "wayfire"          "master"
manual "pkgs/waypipe"
update "pkgs/wf-config"        "WayfireWM"  "wf-config"        "master"
update "pkgs/wf-recorder"      "ammen99"    "wf-recorder"      "master"
update "pkgs/wl-clipboard"     "bugaevc"    "wl-clipboard"     "master"
manual "pkgs/waypipe"
update "pkgs/wldash"           "kennylevinsen" "wldash"        "master"
manual "pkgs/wlrobs"
update "pkgs/wlroots"          "swaywm"     "wlroots"          "master"
manual "pkgs/wltrunk"
update "pkgs/wtype"            "atx"  "wtype"  "master"
update "pkgs/xdg-desktop-portal-wlr" "emersion" "xdg-desktop-portal-wlr" "master"

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

# build and push
nix-build \
  --no-out-link \
    --option "extra-binary-caches" "https://cache.nixos.org https://colemickens.cachix.org https://nixpkgs-wayland.cachix.org" \
  --option "trusted-public-keys" "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= colemickens.cachix.org-1:oIGbn9aolUT2qKqC78scPcDL6nz7Npgotu644V4aGl4= nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA=" \
  build.nix -A all | cachix push "${cachixremote}"

for m in "${manual[@]}"; do
  echo "UPDATE MANUALLY: ${m}"
done
