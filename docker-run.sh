#!/bin/bash

if [ $# -lt 1 ]; then
  echo "$0 <build>"
  echo ""
  echo "example:"
  echo "  $0 clang"
  exit 1
fi

BASE_DIR=$(cd $(dirname $0); pwd)
docker run -it --net=host -v $BASE_DIR:/var/work -v /tmp/wandbox:/opt/wandbox melpon/wandbox:$1 /bin/bash -c "cd /var/work/$1 && exec /bin/bash"
