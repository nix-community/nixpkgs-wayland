#!/usr/bin/env bash

set -euo pipefail
set -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# keep track of what we build for the README
defaultcommitmsg="auto-updates:"
pkgentries=(); nixpkgentries=(); commitmsg="${defaultcommitmsg}";
cache="nixpkgs-wayland";
build_attr="${1:-"waylandPkgs"}"

up=0 # updated_performed # up=$(( $up + 1 ))

unset NIX_PATH

git status
git add -A .
git status
if ! git diff-index --cached --quiet HEAD; then
  echo "You have local changes. boo." &> /dev/stderr
  exit 1
fi

function update() {
  set +x
  typ="${1}"
  pkg="${2}"

  echo "============================================================================"
  echo "${pkg}: checking"

  metadata="${pkg}/metadata.nix"
  pkgname="$(basename "${pkg}")"

  # TODO: nix2json, update in parallel
  # TODO: aka, not in bash

  branch="$(nix-instantiate "${metadata}" --eval --json -A branch 2>/dev/null | jq -r .)"
  rev="$(nix-instantiate "${metadata}" --eval --json -A rev  2>/dev/null | jq -r .)"
  date="$(nix-instantiate "${metadata}" --eval --json -A revdate  2>/dev/null | jq -r .)"
  sha256="$(nix-instantiate "${metadata}" --eval --json -A sha256  2>/dev/null | jq -r .)"
  upattr="$(nix-instantiate "${metadata}" --eval --json -A upattr  2>/dev/null | jq -r . || echo "${pkgname}")"
  url="$(nix-instantiate "${metadata}" --eval --json -A url  2>/dev/null | jq -r . || echo "missing_url")"
  cargoSha256="$(nix-instantiate "${metadata}" --eval --json -A cargoSha256  2>/dev/null | jq -r . || echo "missing_cargoSha256")"
  vendorSha256="$(nix-instantiate "${metadata}" --eval --json -A vendorSha256  2>/dev/null | jq -r . || echo "missing_vendorSha256")"
  skip="$(nix-instantiate "${metadata}" --eval --json -A skip  2>/dev/null | jq -r . || echo "false")"

  newdate="${date}"
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
      up=$(( $up + 1 ))
      commitmsg="${commitmsg} ${pkgname},"

      echo "${pkg}: ${rev} => ${newrev}"

      set -x

      # Update RevDate
      d="$(mktemp -d)"
      if [[ "${repotyp}" == "git" ]]; then
        git clone -b "${branch}" --single-branch --depth=1 "${repo}" "${d}" &>/dev/null
        newdate="$(cd "${d}"; TZ=UTC git show --quiet --date='format-local:%Y-%m-%d %H:%M:%SZ' --format="%cd")"
      elif [[ "${repotyp}" == "hg" ]]; then
        hg clone "${repo}#${branch}" "${d}"
        newdate="$(cd "${d}"; TZ=UTC hg log -l1 --template "{date(date, '%Y-%m-%d %H:%M:%S')}\n")" &>/dev/null
      fi
      rm -rf "${d}"

      # Update Sha256
      if [[ "${typ}" == "pkgs" ]]; then
        newsha256="$(NIX_PATH="${tmpnixpath}" nix-prefetch --output raw \
            -E "(import ./build.nix).${upattr}" \
            --rev "${newrev}")"
      elif [[ "${typ}" == "nixpkgs" ]]; then
        newsha256="$(NIX_PATH="${tmpnixpath}" nix-prefetch-url --unpack "${url}" 2>/dev/null)"
      fi

      # TODO: do this with nix instead of sed?
      sed -i "s/${rev}/${newrev}/" "${metadata}"
      sed -i "s|${date}|${newdate}|" "${metadata}"
      sed -i "s/${sha256}/${newsha256}/" "${metadata}"

      # CargoSha256 has to happen AFTER the other rev/sha256 bump
      if [[ "${cargoSha256}" != "missing_cargoSha256" ]]; then
        newcargoSha256="$(NIX_PATH="${tmpnixpath}" \
          nix-prefetch \
            "{ sha256 }: let p=(import ./build.nix).${upattr}; in p.cargoDeps.overrideAttrs (_: { cargoSha256 = sha256; })")"
        sed -i "s/${cargoSha256}/${newcargoSha256}/" "${metadata}"
      fi

      # VendorSha256 has to happen AFTER the other rev/sha256 bump
      if [[ "${vendorSha256}" != "missing_vendorSha256" ]]; then
        newvendorSha256="$(NIX_PATH="${tmpnixpath}" \
          nix-prefetch \
            "{ sha256 }: let p=(import ./build.nix).${upattr}; in p.go-modules.overrideAttrs (_: { vendorSha256 = sha256; })")"
        sed -i "s/${vendorSha256}/${newvendorSha256}/" "${metadata}"
      fi

      set +x
    fi
  fi

  if [[ "${skip}" == "true" ]]; then
    newdate="${newdate} (pinned)"
  fi
  if [[ "${typ}" == "pkgs" ]]; then
    desc="$(nix-instantiate --eval -E "(import ./build.nix).${upattr}.meta.description" | jq -r .)"
    home="$(nix-instantiate --eval -E "(import ./build.nix).${upattr}.meta.homepage" | jq -r .)"
    pkgentries=("${pkgentries[@]}" "| [${pkgname}](${home}) | ${newdate} | ${desc} |");
  elif [[ "${typ}" == "nixpkgs" ]]; then
    nixpkgentries=("${nixpkgentries[@]}" "| ${pkgname} | ${newdate} |");
  fi
}

function update_readme() {
  set +x

  replace="$(printf "<!--pkgs-->")"
  replace="$(printf "%s\n| Package | Last Updated (UTC) | Description |" "${replace}")"
  replace="$(printf "%s\n| ------- | ------------------ | ----------- |" "${replace}")"
  for p in "${pkgentries[@]}"; do
    replace="$(printf "%s\n%s\n" "${replace}" "${p}")"
  done
  replace="$(printf "%s\n<!--pkgs-->" "${replace}")"

  rg --multiline '(?s)(.*)<!--pkgs-->(.*)<!--pkgs-->(.*)' "README.md" \
    --replace "\$1${replace}\$3" \
      > README2.md; mv README2.md README.md

  replace="$(printf "<!--nixpkgs-->")"
  replace="$(printf "%s\n| Channel | Last Channel Commit Time |" "${replace}")"
  replace="$(printf "%s\n| ------- | ------------------------ |" "${replace}")"
  for p in "${nixpkgentries[@]}"; do
    replace="$(printf "%s\n%s\n" "${replace}" "${p}")"
  done
  replace="$(printf "%s\n<!--nixpkgs-->" "${replace}")"

  rg --multiline '(?s)(.*)<!--nixpkgs-->(.*)<!--nixpkgs-->(.*)' "README.md" \
    --replace "\$1${replace}\$3" \
      > README2.md; mv README2.md README.md
}

rm -f .ci/commit-message

tmpnixpath="nixpkgs=$(nix-instantiate --eval --json ./nixpkgs/nixos-unstable/default.nix | jq -r .)"

for p in nixpkgs/*; do
  update "nixpkgs" "${p}"
done

tmpnixpath="nixpkgs=$(nix-instantiate --eval --json ./nixpkgs/nixos-unstable/default.nix | jq -r .)"

for p in pkgs/*; do
  update "pkgs" "${p}"
done

update_readme

set -x

#nix-build-uncached -build-flags "\
nix-build \
  --option "extra-binary-caches" "https://cache.nixos.org https://nixpkgs-wayland.cachix.org" \
  --option "trusted-public-keys" "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA=" \
  --option "build-cores" "0" \
  --option "narinfo-cache-negative-ttl" "0" \
  --keep-going --no-out-link build.nix | cachix push "${cache}"

if [[ "${commitmsg}" == "${defaultcommitmsg}" ]]; then
  # there's *nothing* to do, so just exit
  git restore -- . # this is a workaround. sometimes no-ops modify the readme
  exit 0
fi

git status
git add -A .
git status
git diff-index --cached --quiet HEAD || git commit -m "${commitmsg}"
git push origin HEAD

