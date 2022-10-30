#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
set -euo pipefail
set -x

unset NIX_PATH
pkgentries=(); nixpkgentries=();
cache="nixpkgs-wayland"
cprefix="auto-update:"

nixargs=(--experimental-features 'nix-command flakes')
buildargs=(
  --option 'extra-binary-caches' 'https://cache.nixos.org https://nixpkgs-wayland.cachix.org'
  --option 'trusted-public-keys' 'cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA='
  --option 'build-cores' '0'
  --option 'narinfo-cache-negative-ttl' '0'
)

function readme_entry() {
  t="$(mktemp)"; trap "rm ${t}" EXIT;
  m="$(mktemp)"; trap "rm ${m}" EXIT;
  pkg="${1}"
  metadata="${pkg}/metadata.nix"
  pkgname="$(basename "${pkg}")"
  if [[ ! -f "${pkg}/metadata.nix" ]]; then return; fi
  nix "${nixargs[@]}" eval -f "${metadata}" --json > "${t}" 2>/dev/null
  upattr="$(cat "${t}" | jq -r .upattr)";
  if [[ "${upattr}" == "null" ]]; then upattr="${pkgname}"; fi
  nix "${nixargs[@]}" eval --json ".#${upattr}.meta" > "${m}" 2>/dev/null
  desc="$(cat "${m}" | jq -r .description)"
  home="$(cat "${m}" | jq -r .homepage)"
  pkgentries=("${pkgentries[@]}" "| [${pkgname}](${home}) | ${desc} |");
}

function update_readme() {
  replace="$(printf "%s\n%s\n%s" "<!--pkgs-->" "| Package | Description |" "| --- | --- |")"
  for p in "${pkgentries[@]}"; do
    replace="$(printf "%s\n%s\n" "${replace}" "${p}")"
  done
  replace="$(printf "%s\n<!--pkgs-->" "${replace}")"
  rg --multiline '(?s)(.*)<!--pkgs-->(.*)<!--pkgs-->(.*)' "README.md" --replace "\$1${replace}\$3" > README2.md
  mv README2.md README.md
}

action="${1}"; shift


if [[ "${action}" == "advance" || "${action}" == "update" ]]; then
  ##
  ## Advance nixpkgs 
  nix "${nixargs[@]}" flake update --commit-lock-file
fi


if [[ "${action}" == "update" ]]; then
  ##
  ## Update pkgs 
  if [[ "${1:-""}" != "_nixpkgs" ]]; then
    # rewrite readme for consistency's sake
    pkgslist=()
    for p in `ls -v -d -- ./pkgs/*/ | sort -V`; do
      readme_entry "${p}"
    done
    update_readme
    git commit README.md -m "${cprefix} README.md" || true
  
    # actual internal update
    "${DIR}/pkgs/update.sh"
    echo "internal update status = $?"
    cd "${DIR}"
  fi
fi

##
## Build uncached 
set -x
out="$(mktemp -d)"
nix-build-uncached -build-flags "$(printf '\"%s\" ' "${buildargs[@]}" "${nixargs[@]}" "--out-link" "${out}/result")" packages.nix

##
## Push anything built to Cachix
if find ${out} | grep result; then
  nix "${nixargs[@]}" path-info --json -r ${out}/result* > ${out}/path-info.json
  jq -r 'map(select(.ca == null and .signatures == null)) | map(.path) | .[]' < "${out}/path-info.json" > "${out}/paths"

  set +x
  if [[ "${CACHIX_SIGNING_KEY_NIXPKGS_WAYLAND:-}" != "" ]]; then
    export CACHIX_SIGNING_KEY="${CACHIX_SIGNING_KEY_NIXPKGS_WAYLAND}"
  fi
  set -x

  cat "${out}/paths" \
    | tee /dev/stderr \
    | cachix push "${cache}" < "${out}/paths"
fi

if [[ "${action}" == "advance" || "${action}" == "update" ]]; then
  ##
  ## Push to `master`
  git push origin HEAD
fi
