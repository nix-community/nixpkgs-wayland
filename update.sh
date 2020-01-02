#!/usr/bin/env bash

set -euo pipefail
set -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# keep track of what we build for the README
pkgentries=(); nixpkgentries=();
cache="nixpkgs-wayland";
build_attr="${1:-"waylandPkgs"}"

up=0 # updated_performed # up=$(( $up + 1 ))

function update() {
  typ="${1}"
  pkg="${2}"

  metadata="${pkg}/metadata.nix"
  pkgname="$(basename "${pkg}")"

  branch="$(nix eval --raw -f "${metadata}" branch)"
  rev="$(nix eval --raw -f "${metadata}" rev)"
  date="$(nix eval --raw -f "${metadata}" revdate)"
  sha256="$(nix eval --raw -f "${metadata}" sha256)"
  upattr="$(nix eval --raw -f "${metadata}" upattr || echo "${pkgname}")"
  skip="$(nix eval -f "${metadata}" skip || true)"

  newdate="${date}"
  if [[ "${skip}" != "true" ]]; then
    # Determine RepoTyp (git/hg)
    if   nix eval --raw -f "${metadata}" repo_git; then repotyp="git";
    elif nix eval --raw -f "${metadata}" repo_hg;  then repotyp="hg";
    else echo "unknown repo_typ" && exit -1;
    fi

    # Update Rev
    if [[ "${repotyp}" == "git" ]]; then
      repo="$(nix eval --raw -f "${metadata}" repo_git)"
      newrev="$(git ls-remote "${repo}" "${branch}" | awk '{ print $1}')"
    elif [[ "${repotyp}" == "hg" ]]; then
      repo="$(nix eval --raw -f "${metadata}" repo_hg)"
      newrev="$(hg identify "${repo}" -r "${branch}")"
    fi
    
    if [[ "${rev}" != "${newrev}" ]]; then
      up=$(( $up + 1 ))

      # Update RevDate
      d="$(mktemp -d)"
      if [[ "${repotyp}" == "git" ]]; then
        git clone -b "${branch}" --single-branch --depth=1 "${repo}" "${d}"
        newdate="$(cd "${d}"; git log --format=%ci --max-count=1)"
      elif [[ "${repotyp}" == "hg" ]]; then
        hg clone "${repo}#${branch}" "${d}"
        newdate="$(cd "${d}"; hg log -r1 --template '{date|isodate}')"
      fi
      rm -rf "${d}"

      # Update Sha256
      # TODO: nix-prefetch without NIX_PATH?
      if [[ "${typ}" == "pkgs" ]]; then
        newsha256="$(NIX_PATH=nixpkgs=https://github.com/nixos/nixpkgs/archive/nixos-unstable.tar.gz \
          nix-prefetch \
            -E "(import ./build.nix).${upattr}" \
            --rev "${newrev}" \
            --output raw)"
      elif [[ "${typ}" == "nixpkgs" ]]; then
        # TODO: why can't nix-prefetch handle this???
        url="$(nix eval --raw -f "${metadata}" url)"
        newsha256="$(NIX_PATH=nixpkgs=https://github.com/nixos/nixpkgs/archive/nixos-unstable.tar.gz \
          nix-prefetch-url --unpack "${url}")"
      fi

      # TODO: do this with nix instead of sed?
      sed -i "s/${rev}/${newrev}/" "${metadata}"
      sed -i "s/${date}/${newdate}/" "${metadata}"
      sed -i "s/${sha256}/${newsha256}/" "${metadata}"
    fi
  fi

  if [[ "${skip}" == "true" ]]; then
    newdate="${newdate} (pinned)"
  fi
  if [[ "${typ}" == "pkgs" ]]; then
    desc="$(nix eval --raw "(import ./build.nix).${pkgname}.meta.description")"
    home="$(nix eval --raw "(import ./build.nix).${pkgname}.meta.homepage")"
    pkgentries=("${pkgentries[@]}" "| [${pkgname}](${home}) | ${newdate} | ${desc} |");
  elif [[ "${typ}" == "nixpkgs" ]]; then
    nixpkgentries=("${nixpkgentries[@]}" "| ${pkgname} | ${newdate} |");
  fi
}

function update_readme() {
  replace="$(printf "<!--pkgs-->")"
  replace="$(printf "%s\n| Package | Last Update | Description |" "${replace}")"
  replace="$(printf "%s\n| ------- | ----------- | ----------- |" "${replace}")"
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
  set -x

  rg --multiline '(?s)(.*)<!--nixpkgs-->(.*)<!--nixpkgs-->(.*)' "README.md" \
    --replace "\$1${replace}\$3" \
      > README2.md; mv README2.md README.md
}

for p in nixpkgs/*; do
  update "nixpkgs" "${p}"
done

for p in pkgs/*; do
  update "pkgs" "${p}"
done

update_readme

if [[ ! -z "${CI_BUILD:-""}" ]]; then
  if ! expr $(git status --porcelain 2>/dev/null| egrep "^(M| M)" | wc -l); then
    echo "This is a CI build with no changes. Refusing to build again."
    exit 0
  fi
fi

cachix push -w "${cache}" &
CACHIX_PID="$!"
trap "kill ${CACHIX_PID}" EXIT

./nixbuild.sh build.nix \
  --no-out-link --keep-going \
  | cachix push "${cache}"

