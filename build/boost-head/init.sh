#!/bin/bash

. ../init.sh

function check_version() {
  version=$1
  compiler=$2

  while read line; do
    if [ "$version $compiler" = "$line" ]; then
      return 0
    fi
  done < VERSIONS
  return 1
}
