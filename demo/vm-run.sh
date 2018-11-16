#!/usr/bin/env bash

if [[ ! -e ./result ]]; then
  echo Run ./vm-build.sh first
  exit 1
fi

exec ./result/bin/run-nixos-vm
