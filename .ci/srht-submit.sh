#!/usr/bin/env bash
set -x

# user-specific
SECRET_NAME="cole.mickens@gmail.com/meta.sr.ht"
SECRET_ATTR="pat"

# less user-specific
BUILD_HOST="https://builds.sr.ht"
TOKEN="$(gopass show "${SECRET_NAME}" | grep "${SECRET_ATTR}" | cut -d' ' -f2)"

DATA="$(mktemp)"
MANIFEST="$(jq -aRs . <'./srht-job.yaml')"
echo "{ \"manifest\": ${MANIFEST} }" > "${DATA}"

curl --verbose \
  -H "Authorization:token ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d "@${DATA}" \
  "${BUILD_HOST}/api/jobs"