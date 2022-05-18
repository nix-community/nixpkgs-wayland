#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
set -euo pipefail
set -x

unset NIX_PATH
cd "${DIR}"

# build up commit msg
cprefix="auto-update(${JOB_ID:-"manual"}):"

nixargs=(--experimental-features 'nix-command flakes')
buildargs=(
  --option 'extra-binary-caches' 'https://cache.nixos.org https://nixpkgs-wayland.cachix.org'
  --option 'trusted-public-keys' 'cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA='
  --option 'build-cores' '0'
  --option 'narinfo-cache-negative-ttl' '0'
)

## the rest should be generic across repos that use `update.sh`+`metadata.nix`

if [[ "${1:-""}" != "" ]]; then
  ##
  ## internal script (called in parallel)
  ##
  t="$(mktemp)"; trap "rm ${t}" EXIT;
  m="$(mktemp)"; trap "rm ${m}" EXIT;
  l="$(mktemp)"; trap "rm ${l}" EXIT;
  pkg="${1}"
  metadata="${pkg}/metadata.nix"
  pkgname="$(basename "${pkg}")"

  if [[ ! -f "${pkg}/metadata.nix" ]]; then exit 0; fi

  nix "${nixargs[@]}" eval -f "${metadata}" --json > "${t}" 2>/dev/null
  branch="$(cat "${t}" | jq -r .branch)"
  rev="$(cat "${t}" | jq -r .rev)"
  sha256="$(cat "${t}" | jq -r .sha256)"
  upattr="$(cat "${t}" | jq -r .upattr)";  # optional, but set if not user-set
  if [[ "${upattr}" == "null" ]]; then upattr="${pkgname}"; fi
  url="$(cat "${t}" | jq -r .url)" # optional
  cargoSha256="$(cat "${t}" | jq -r .cargoSha256)" # optional
  vendorSha256="$(cat "${t}" | jq -r .vendorSha256)" # optional
  skip="$(cat "${t}" | jq -r .skip)" # optional
  repo_git="$(cat "${t}" | jq -r .repo_git)" # optional
  repo_hg="$(cat "${t}" | jq -r .repo_hg)" # optional

  if [[ "${skip}" == "true" ]]; then
    echo "skipping (pinned to ${rev})"
    exit 0
  fi

  # grab the latest rev from the repo (supports: git, merucurial)
  if [[ "${repo_git}" != "null" ]]; then
    repotyp="git";
    repo="${repo_git}"
    newrev="$(git ls-remote "${repo}" "refs/heads/${branch}" | awk '{ print $1}')"
  elif [[ "${repo_hg}" != "null" ]]; then
    repotyp="hg";
    repo="${repo_hg}"
    newrev="$(hg identify "${repo}" -r "${branch}")"
  else
    echo "unknown repo_typ"
    exit 1;
  fi

  # early quit if we don't need to update
  if [[ "${rev}" == "${newrev}" && "${FORCE_RECHECK:-""}" != "true" ]]; then
    echo "up-to-date (${rev})"
    exit 0
  fi

  echo "${rev} => ${newrev}"

  # Update Sha256
  sed -i "s|${rev}|${newrev}|" "${metadata}"; echo $?
  sed -i "s|${sha256}|0000000000000000000000000000000000000000000000000000|" "${metadata}"
  nix "${nixargs[@]}" build --no-link "..#${upattr}" &> "${l}" || true
  newsha256="$(cat "${l}" | grep 'got:' | cut -d':' -f2 | tr -d ' ' || true)"
  if [[ "${newsha256}" == "sha256" ]]; then newsha256="$(cat "${l}" | grep 'got:' | cut -d':' -f3 | tr -d ' ' || true)"; fi

  newsha256="$(nix "${nixargs[@]}" hash to-sri --type sha256 "${newsha256}")"
  sed -i "s|0000000000000000000000000000000000000000000000000000|${newsha256}|" "${metadata}"

  # CargoSha256 has to happen AFTER the other rev/sha256 bump
  if [[ "${cargoSha256}" != "null" ]]; then
    sed -i "s|${cargoSha256}|0000000000000000000000000000000000000000000000000000|" "${metadata}"
    nix "${nixargs[@]}" build --no-link "..#${upattr}" &> "${l}" || true
    newcargoSha256="$(cat "${l}" | grep 'got:' | cut -d':' -f2 | tr -d ' ' || true)"
    if [[ "${newcargoSha256}" == "sha256" ]]; then newcargoSha256="$(cat "${l}" | grep 'got:' | cut -d':' -f3 | tr -d ' ' || true)"; fi
    newcargoSha256="$(nix "${nixargs[@]}" hash to-sri --type sha256 "${newcargoSha256}")"
    sed -i "s|0000000000000000000000000000000000000000000000000000|${newcargoSha256}|" "${metadata}"
  fi

  # VendorSha256 has to happen AFTER the other rev/sha256 bump
  if [[ "${vendorSha256}" != "null" ]]; then
    sed -i "s|${vendorSha256}|0000000000000000000000000000000000000000000000000000|" "${metadata}"
    nix "${nixargs[@]}" build --no-link "..#${upattr}" &> "${l}" || true
    newvendorSha256="$(cat "${l}" | grep 'got:' | cut -d':' -f2 | tr -d ' ' || true)"
    if [[ "${newvendorSha256}" == "sha256" ]]; then newvendorSha256="$(cat "${l}" | grep 'got:' | cut -d':' -f3 | tr -d ' ' || true)"; fi
    newvendorSha256="$(nix "${nixargs[@]}" hash to-sri --type sha256 "${newvendorSha256}")"
    sed -i "s|0000000000000000000000000000000000000000000000000000|${newvendorSha256}|" "${metadata}"
  fi

  # Commit
  git diff-index --quiet HEAD "${pkg}" || \
    git commit "${pkg}" -m "${cprefix} ${pkgname}: ${rev} => ${newrev}"
  echo "done updating ${pkg} (${rev} => ${newrev})"
  exit 0
fi

##
## main script
##

# updates galore
pkgslist=()
for p in `ls -v -d -- ./*/ | sort -V`; do
  "${0}" "${p}"
done

exit 0
