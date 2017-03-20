#!/bin/bash

if [ $# -lt 2 ]; then
  echo "$0 <build> <command> [<args>...]"
  echo ""
  echo "example:"
  echo "  $0 clang ./install.sh"
  exit 1
fi

BASE_DIR=$(cd $(dirname $0); pwd)
docker run \
  --net=host \
  -v $BASE_DIR:/var/work \
  -v $BASE_DIR/../wandbox:/opt/wandbox \
  -w "/var/work/$1"
  "melpon/wandbox:$1" "$2" "${@:3}"
