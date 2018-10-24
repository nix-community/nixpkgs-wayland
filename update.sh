#!/usr/bin/env bash
set -euo pipefail
set -x

# TODO: update this for the overlay repo
# make it spit out <pkg_name>/metadata.nix with
# {
#   url = "${rev}";
#   sha256 = "${sha256}";
# }

##
## use github api to get latest commit for a repo
## use nix-prefetch-url to get the hash
## update files in place with `update-source-version`
##

export nixpkgs=/etc/nixpkgs-sway
export NIX_PATH=nixpkgs=${nixpkgs}

# update: <derivation-name> <github-repo-owner> <github-repo-name>
function update() {
  attr="${1}"
  owner="${2}"
  repo="${3}"
  rev="$(curl --silent --fail "https://api.github.com/repos/${owner}/${repo}/commits" | jq -r ".[0].sha")"
  sha256="$(nix-prefetch-url --unpack "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz" 2>/dev/null)"

  #pushd "${nixpkgs}" >/dev/null
  #echo "Updating attribute '${attr}'."
  #"${nixpkgs}/pkgs/common-updater/scripts/update-source-version" "${attr}" "${rev}" "${sha256}"
  #popd >/dev/null
  cat<<EOF >"./${attr}/metadata.nix"
{
  rev: "${rev}";
  sha256: "${sha256}";
}
EOF
}

update "wlroots"   "swaywm" "wlroots"
update "sway-beta" "swaywm" "sway"
update "slurp"     "emersion" "slurp"
update "grim"      "emersion" "grim"
update "wlstream"  "atomnuker" "wlstream"

