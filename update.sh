#!/usr/bin/env bash
set -euo pipefail
set -x

export nixpkgs=/etc/nixpkgs-sway
export NIX_PATH=nixpkgs=${nixpkgs}

GHUSER="${GHUSER:-"$(cat /etc/nixos/secrets/github-username)"}"
GHPASS="${GHPASS:-"$(cat /etc/nixos/secrets/github-token)"}"

# update: <derivation-name> <github-repo-owner> <github-repo-name> <ref>
function update() {
  attr="${1}"
  owner="${2}"
  repo="${3}"
  ref="${4}"
  rev="$(curl -u "${GHUSER}:${GHPASS}" --silent --fail "https://api.github.com/repos/${owner}/${repo}/commits?sha=${ref}" | jq -r ".[0].sha")"
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
if [[ -z "${SKIP:-}" ]]; then
update "wlroots"   "swaywm"    "wlroots"          "master"
update "sway-beta" "swaywm"    "sway"             "master"
update "slurp"     "emersion"  "slurp"            "master"
update "grim"      "emersion"  "grim"             "master"
update "wlstream"  "atomnuker" "wlstream"         "master"
update "waybar"    "Alexays"   "waybar"           "master"
update "nixpkgs"   "nixos"     "nixpkgs-channels" "nixos-unstable"
fi

results="$(nix-build --no-out-link build.nix)"
readarray -t out <<< "$(echo "${results}")"

d="$(date -Iseconds)"
m="(.+)"
t="<!--update-->"
sed -i -E "s/${t}${m}${t}/${t}${d}${t}/g" README.md

if [[ -e "/etc/nixcfg/utils/azure/nix-copy-azure.sh" ]]; then
  "/etc/nixcfg/utils/azure/nix-copy-azure.sh" "${out[@]}"
fi
