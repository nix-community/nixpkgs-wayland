#!/usr/bin/env bash
set -euo pipefail
set -x

cachixremote="nixpkgs-wayland"
GHUSER="${GHUSER:-"$(cat /etc/nixos/secrets/github-username)"}"
GHPASS="${GHPASS:-"$(cat /etc/nixos/secrets/github-token)"}"

# keep track of what we build and only upload at the end
builtattrs=()
pkgentries=()

function update() {
  attr="${1}"
  owner="${2}"
  repo="${3}"
  ref="${4}"

  rev=""
  commitdate=""
  url="https://api.github.com/repos/${owner}/${repo}/commits?sha=${ref}"
  commit="$(curl --silent --fail "${url}")"
  #commit="$(curl -u "${GHUSER}:${GHPASS}" --silent --fail "${url}")"
  rev="$(echo "${commit}" | jq -r ".[0].sha")"
  commitdate="$(echo "${commit}" | jq -r ".[0].commit.committer.date")"
  sha256="$(nix-prefetch-url --unpack "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz" 2>/dev/null)"

  printf '==> update: %s/%s: %s\n' "${owner}" "${repo}" "${rev}"
  mkdir -p "./${attr}"
  printf '{\n  rev = "%s";\n  sha256 = "%s";\n}\n' "${rev}" "${sha256}" > "./${attr}/metadata.nix"

  if [[ "${attr}" == "nixpkgs" ]]; then return; fi

  printf '==> build: %s/%s: %s\n' "${owner}" "${repo}" "${rev}"
  results="$(nix-build --no-out-link build.nix -A "${attr}")"
  readarray -t out <<< "$(echo "${results}")"
  builtattrs=("${builtattrs[@]}" "${out[@]}")

  d="$(date '+%Y-%m-%d %H:%M' --date="${commitdate}")"
  m='(.*)'
  txt="| ${attr} | [${d}](https://github.com/${owner}/${repo}/commits/${rev}) |"
  pkgentries=("${pkgentries[@]}" "${txt}")
}

#      attr_name          repo_owner   repo_name          repo_rev
update "nixpkgs"          "nixos"      "nixpkgs-channels" "nixos-unstable"
update "wlroots"          "swaywm"     "wlroots"          "master"
update "sway-beta"        "swaywm"     "sway"             "master"
update "slurp"            "emersion"   "slurp"            "master"
update "grim"             "emersion"   "grim"             "master"
update "mako"             "emersion"   "mako"             "master"
update "wlstream"         "atomnuker"  "wlstream"         "master"
update "waybar"           "Alexays"    "waybar"           "master"
update "wayfire"          "WayfireWM"  "wayfire"          "master"
update "wf-config"        "WayfireWM"  "wf-config"        "master"
update "redshift-wayland" "minus7"     "redshift"         "wayland"

#update "bspwc"      "Bl4ckb0ne"  "bspwc"            "master"
#update "mahogany"   "sdilts"     "mahogany"         "master"
#update "tablecloth" "topisani"   "tablecloth"       "master"
#update "trinkster"  "Dreyri"     "trinkster"        "master"
#update "way-cooler" "way-cooler" "way-cooler"       "master"
#update "waybox"     "wizbright"  "waybox"           "master"
#update "waymonad"   "waymonad"   "waymonad"         "master"

# update README.md
replace="$(printf "<!--pkgs-->")"
replace="$(printf "%s\n| Attribute Name | Last Upstream Commit Time |" "${replace}")"
replace="$(printf "%s\n| -------------- | ------------------------- |" "${replace}")"
for p in "${pkgentries[@]}"; do
  replace="$(printf "%s\n%s\n" "${replace}" "${p}")"
done
replace="$(printf "%s\n<!--pkgs-->" "${replace}")"

rg \
  --multiline '(?s)(.*)<!--pkgs-->(.*)<!--pkgs-->(.*)' \
  "README.md" \
  --replace "\$1${replace}\$3" \
  > README2.md; mv README2.md README.md
rg \
  --multiline '(?s)(.*)<!--update-->(.*)<!--update-->(.*)' \
  "README.md" \
  --replace "\$1<!--update-->$(date '+%Y-%m-%d %H:%M')<!--update-->\$3" \
  > README2.md; mv README2.md README.md

nix-build build.nix | cachix push "${cachixremote}"

