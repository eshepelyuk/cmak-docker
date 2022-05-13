# list available recipes
default:
  just --list

_latest:
  #!/bin/sh
  if [ -n "$(echo ${SKAFFOLD_IMAGE}|grep '^ghcr')" ]; then
    crane tag ${SKAFFOLD_IMAGE} latest
  fi
