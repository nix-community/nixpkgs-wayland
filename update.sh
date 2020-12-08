#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
set -euo pipefail
set -x

unset NIX_PATH

# TODO `NIX_PATH` should be derived from the flake.lock

# build up commit msg
defaultcommitmsg="auto-updates:"
commitmsg="${defaultcommitmsg}";

# keep track of what we build for the README
pkgentries=(); nixpkgentries=();
cache="nixpkgs-wayland";
build_attr="${1:-"waylandPkgs"}"

buildargs=(
  --option 'extra-binary-caches' 'https://cache.nixos.org https://nixpkgs-wayland.cachix.org'
  --option 'trusted-public-keys' 'cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA='
  --option 'build-cores' '0'
  --option 'narinfo-cache-negative-ttl' '0'
)

# use the same nixpkgs we already have downloaded
nixpkgs="https://api.github.com/repos/$(jq -r '.nodes.nixpkgs.locked.owner' flake.lock)/$(jq -r '.nodes.nixpkgs.locked.repo' flake.lock)/tarball/$(jq -r '.node.nixpkgs.locked.rev' flake.lock)"

function update() {
  typ="${1}"
  pkg="${2}"

  echo "============================================================================"
  echo "${pkg}: checking"

  metadata="${pkg}/metadata.nix"
  pkgname="$(basename "${pkg}")"

  if [[ ! -f "${pkg}/metadata.nix" ]]; then return; fi

  # TODO: nix2json, update in parallel
  # TODO: aka, not in bash

  branch="$(nix-instantiate "${metadata}" --eval --json -A branch 2>/dev/null | jq -r .)"
  rev="$(nix-instantiate "${metadata}" --eval --json -A rev  2>/dev/null | jq -r .)"
  sha256="$(nix-instantiate "${metadata}" --eval --json -A sha256  2>/dev/null | jq -r .)"
  upattr="$(nix-instantiate "${metadata}" --eval --json -A upattr  2>/dev/null | jq -r . || echo "${pkgname}")"
  url="$(nix-instantiate "${metadata}" --eval --json -A url  2>/dev/null | jq -r . || echo "missing_url")"
  cargoSha256="$(nix-instantiate "${metadata}" --eval --json -A cargoSha256  2>/dev/null | jq -r . || echo "missing_cargoSha256")"
  vendorSha256="$(nix-instantiate "${metadata}" --eval --json -A vendorSha256  2>/dev/null | jq -r . || echo "missing_vendorSha256")"
  skip="$(nix-instantiate "${metadata}" --eval --json -A skip  2>/dev/null | jq -r . || echo "false")"

  if [[ "${skip}" != "true" ]]; then
    # Determine RepoTyp (git/hg)
    if   nix-instantiate "${metadata}" --eval --json -A repo_git &>/dev/null; then repotyp="git";
    elif nix-instantiate "${metadata}" --eval --json -A repo_hg &>/dev/null; then repotyp="hg";
    else echo "unknown repo_typ" && exit 1;
    fi

    # Update Rev
    if [[ "${repotyp}" == "git" ]]; then
      repo="$(nix-instantiate "${metadata}" --eval --json -A repo_git | jq -r .)"
      newrev="$(git ls-remote "${repo}" "${branch}" | awk '{ print $1}')"
    elif [[ "${repotyp}" == "hg" ]]; then
      repo="$(nix-instantiate "${metadata}" --eval --json -A repo_hg | jq -r .)"
      newrev="$(hg identify "${repo}" -r "${branch}")"
    fi

    if [[ "${rev}" != "${newrev}" ]]; then
      commitmsg="${commitmsg} ${pkgname},"

      echo "${pkg}: ${rev} => ${newrev}"

      set -x

      # Update Sha256
      if [[ "${typ}" == "pkgs" ]]; then
        newsha256="$(NIX_PATH="nixpkgs=${nixpkgs}" \
          nix-prefetch --output raw \
            -E "(import ./packages.nix).${upattr}" \
            --rev "${newrev}")"
      elif [[ "${typ}" == "nixpkgs" ]]; then
        newsha256="$(NIX_PATH="${tmpnixpath}" nix-prefetch-url --unpack "${url}" 2>/dev/null)"
      fi

      # TODO: do this with nix instead of sed?
      sed -i "s/${rev}/${newrev}/" "${metadata}"
      sed -i "s|${sha256}|${newsha256}|" "${metadata}"

      # CargoSha256 has to happen AFTER the other rev/sha256 bump
      if [[ "${cargoSha256}" != "missing_cargoSha256" ]]; then
        newcargoSha256="$(NIX_PATH="nixpkgs=${nixpkgs}" \
          nix-prefetch \
            "{ sha256 }: let p=(import ./packages.nix).${upattr}; in p.cargoDeps.overrideAttrs (_: { cargoSha256 = sha256; })")"
        sed -i "s|${cargoSha256}|${newcargoSha256}|" "${metadata}"
      fi

      # VendorSha256 has to happen AFTER the other rev/sha256 bump
      if [[ "${vendorSha256}" != "missing_vendorSha256" ]]; then
        newvendorSha256="$(NIX_PATH="nixpkgs=${nixpkgs}" \
          nix-prefetch \
            "{ sha256 }: let p=(import ./packages.nix).${upattr}; in p.go-modules.overrideAttrs (_: { vendorSha256 = sha256; })")"
        sed -i "s|${vendorSha256}|${newvendorSha256}|" "${metadata}"
      fi

      set +x
    fi

    if [[ "${typ}" == "pkgs" ]]; then
      desc="$(nix-instantiate --eval -E "(import ./packages.nix).${upattr}.meta.description" | jq -r .)"
      home="$(nix-instantiate --eval -E "(import ./packages.nix).${upattr}.meta.homepage" | jq -r .)"
      pkgentries=("${pkgentries[@]}" "| [${pkgname}](${home}) | ${desc} |");
    elif [[ "${typ}" == "nixpkgs" ]]; then
      nixpkgentries=("${nixpkgentries[@]}" "| ${pkgname} |");
    fi
  fi
}

function update_readme() {
  set +x

  replace="$(printf "<!--pkgs-->")"
  replace="$(printf "%s\n| Package | Description |" "${replace}")"
  replace="$(printf "%s\n| ------- | ----------- |" "${replace}")"
  for p in "${pkgentries[@]}"; do
    replace="$(printf "%s\n%s\n" "${replace}" "${p}")"
  done
  replace="$(printf "%s\n<!--pkgs-->" "${replace}")"

  rg --multiline '(?s)(.*)<!--pkgs-->(.*)<!--pkgs-->(.*)' "README.md" \
    --replace "\$1${replace}\$3" \
      > README2.md; mv README2.md README.md
}

# update our package sources/sha256s
for p in `ls -v -d -- pkgs/*/`; do
  update "pkgs" "${p}"
done
update_readme

set -x 
out="$(mktemp -d)"
# build it!
nix-build-uncached -build-flags "$(printf '\"%s\" ' "${buildargs[@]}")" --out-link "${out}/result" packages.nix

# cache it!
if find ${out} | grep result; then
  nix --experimental-features 'nix-command flakes' \
    path-info --json -r ${out}/result* > ${out}/path-info.json
  jq -r 'map(select(.ca == null and .signatures == null)) | map(.path) | .[]' < "${out}/path-info.json" > "${out}/paths"
  cachix push "${cache}" < "${out}/paths"
fi

# commit it!
if [[ "${JOB_ID:-""}" != "" ]]; then
  git status
  git add -A .
  git status
  git diff-index --cached --quiet HEAD || git commit -m "${commitmsg}"

  echo "we're building on sr.ht, pushing..."
  git push origin HEAD
fi
