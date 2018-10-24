#!/usr/bin/env bash
set -euo pipefail
set -x

##
## use github api to get latest commit for a repo
## use nix-prefetch-url to get the hash
## update files in place with `update-source-version`
##

export nixpkgs=/etc/nixpkgs-sway
export NIX_PATH=nixpkgs=${nixpkgs}

# TODO: ew
token="$(cat /etc/nixos/secrets/github-colebot-token)"

# update: <derivation-name> <github-repo-owner> <github-repo-name> <ref>
function update() {
  attr="${1}"
  owner="${2}"
  repo="${3}"
  ref="${4}"
  rev="$(curl -u colebot:$token --silent --fail "https://api.github.com/repos/${owner}/${repo}/commits?sha=${ref}" | jq -r ".[0].sha")"
  sha256="$(nix-prefetch-url --unpack "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz" 2>/dev/null)"

  mkdir -p "./${attr}"
  cat<<EOF >"./${attr}/metadata.nix"
{
  rev = "${rev}";
  sha256 = "${sha256}";
}
EOF
}

#      attr_name   repo_owner  repo_name          repo_rev
update "wlroots"   "swaywm"    "wlroots"          "master"
update "sway-beta" "swaywm"    "sway"             "master"
update "slurp"     "emersion"  "slurp"            "master"
update "grim"      "emersion"  "grim"             "master"
update "wlstream"  "atomnuker" "wlstream"         "master"
update "waybar"    "Alexays"   "waybar"           "master"
update "nixpkgs"   "nixos"     "nixpkgs-channels" "nixos-unstable"

nix-build build.nix

d="$(date -Iseconds)"
sed -i -E "s/<!---->(.+)<!---->/<!---->${d}<!---->/g" README.md

