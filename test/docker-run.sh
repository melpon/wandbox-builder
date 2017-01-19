#!/bin/bash

if [ $# -lt 1 ]; then
  echo "$0 <build>"
  echo ""
  echo "example:"
  echo "  $0 cattleshed-runtime"
  exit 1
fi

BASE_DIR=$(cd $(dirname $0); pwd)

../build/docker-rm.sh

if [ "$1" = "cattleshed-runtime" ]; then
  docker run \
    --name cattleshed-runtime \
    -it \
    -v $BASE_DIR/../wandbox:/opt/wandbox \
    melpon/wandbox:$1 \
    /bin/bash -c "
      /opt/wandbox/cattleshed/bin/cattleshed \
        -c /opt/wandbox/cattleshed/etc/cattleshed.conf \
        -c /opt/wandbox/conf/compilers.default
      "
elif [ "$1" = "kennel-runtime" ]; then
  # 既に起動している cattleshed-runtime に対して --link する
  docker run \
    --name kennel-runtime \
    --link cattleshed-runtime:cattleshed-runtime \
    -it \
    -v $BASE_DIR/../wandbox:/opt/wandbox \
    -v $BASE_DIR/$1:/var/work \
    melpon/wandbox:$1 \
    /bin/bash -c "
      cd /var/work
      ./run.sh
      "
elif [ "$1" = "kennel-client" ]; then
  # 既に起動している kennel-runtime に対して --link する
  docker run \
    --name kennel-client \
    --link kennel-runtime:kennel-runtime \
    -it \
    -v $BASE_DIR/../wandbox:/opt/wandbox \
    -v $BASE_DIR/$1:/var/work \
    melpon/wandbox:$1 \
    /bin/bash -c "
      cd /var/work
      ./run.sh
      "
else
  exit 1
fi

