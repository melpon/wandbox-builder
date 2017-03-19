#!/bin/bash

if [ $# -lt 1 ]; then
  echo "$0 <build>"
  echo ""
  echo "example:"
  echo "  $0 clang"
  exit 1
fi

BASE_DIR=$(cd $(dirname $0); pwd)

docker run \
  -it \
  -v $BASE_DIR:/var/work \
  -v $BASE_DIR/../wandbox:/opt/wandbox \
  melpon/wandbox:test-server \
  /bin/bash -c "cd /var/work/$1 && exec /bin/bash"
