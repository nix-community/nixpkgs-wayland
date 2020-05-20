#!/usr/bin/env bash
set -euo pipefail
set -x

ssh-keyscan github.com >> ${HOME}/.ssh/known_hosts

git add -A .
git diff-index --cached --quiet HEAD || git commit -m "$(cat .ci/commit-message)"
git push origin HEAD
