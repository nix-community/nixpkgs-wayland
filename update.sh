#!/usr/bin/env bash

set -euo pipefail
set -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "${DIR}"

# keep track of what we build for the README
pkgentries=(); nixpkgentries=();

function update() {
  typ="${1}"
  pkg="${2}"

  metadata="${pkg}/metadata.nix"
  pkgname="$(basename "${pkg}")"

  branch="$(nix eval --raw -f "${metadata}" branch)"
  rev="$(nix eval --raw -f "${metadata}" rev)"
  date="$(nix eval --raw -f "${metadata}" revdate)"
  sha256="$(nix eval --raw -f "${metadata}" sha256)"
  skip="$(nix eval -f "${metadata}" skip || true)"

  if [[ "${skip}" == "true" ]]; then
    return 0
  fi

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
      newsha256="$(NIX_PATH=nixpkgs=https://github.com/nixos/nixpkgs-channels/archive/nixos-unstable.tar.gz
        nix-prefetch \
          -E "(import ./build.nix).nixosUnstable.${pkgname}" \
          --rev "${newrev}" \
          --output raw)"
    elif [[ "${typ}" == "nixpkgs" ]]; then
      # TODO: why can't nix-prefetch handle this???
      url="$(nix eval --raw -f "${metadata}" url)"
      newsha256="$(NIX_PATH=nixpkgs=https://github.com/nixos/nixpkgs-channels/archive/nixos-unstable.tar.gz
        nix-prefetch-url --unpack "${url}")"
    fi

    # TODO: do this with nix instead of sed?
    sed -i "s/${rev}/${newrev}/" "${metadata}"
    sed -i "s/${date}/${newdate}/" "${metadata}"
    sed -i "s/${sha256}/${newsha256}/" "${metadata}"
  fi
}

function update_readme_entries() {
  typ="${1}"
  pkg="${2}"
  metadata="${pkg}/metadata.nix"
  pkgname="$(basename "${pkg}")"
  branch="$(nix eval --raw -f "${metadata}" branch)"
  rev="$(nix eval --raw -f "${metadata}" rev)"
  date="$(nix eval --raw -f "${metadata}" revdate)"
  sha256="$(nix eval --raw -f "${metadata}" sha256)"
  skip="$(nix eval -f "${metadata}" skip || true)"
  if [[ "${skip}" == "true" ]]; then
    date="${date} (pinned)"
  fi
  if [[ "${typ}" == "pkgs" ]]; then
    desc="$(nix eval --raw "(import ./build.nix).nixosUnstable.${pkgname}.meta.description")"
    home="$(nix eval --raw "(import ./build.nix).nixosUnstable.${pkgname}.meta.homepage")"
    pkgentries=("${pkgentries[@]}" "| [${pkgname}](${home}) | ${date} | ${desc} |");
  elif [[ "${typ}" == "nixpkgs" ]]; then
    nixpkgentries=("${nixpkgentries[@]}" "| ${pkgname} | ${date} |");
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
  update_readme_entries "nixpkgs" "${p}"
done

if [[ "${1:-}" != "" ]]; then
  update "pkgs" "pkgs/${1}"
else
  for p in pkgs/*; do
    update "pkgs" "${p}"
  done
fi

for p in pkgs/*; do
  update_readme_entries "pkgs" "${p}"
done
update_readme

nix-build --no-out-link build.nix -A all \
  | cachix push "nixpkgs-wayland"
