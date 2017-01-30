#!/bin/bash

if [ $# -lt 1 ]; then
  echo "$0 <build>"
  echo ""
  echo "example:"
  echo "  $0 test-server"
  exit 1
fi

BASE_DIR=$(cd $(dirname $0); pwd)

../build/docker-rm.sh

if [ "$1" = "test-server" ]; then
  docker run \
    --name test-server \
    -v `pwd`:/var/work \
    -v $BASE_DIR/../wandbox:/opt/wandbox \
    -d \
    --privileged=true \
    melpon/wandbox:test-server \
    /bin/bash -c "
      set -e

      mkdir /usr/share/perl || true
      /opt/wandbox/cattleshed/bin/cattleshed \
        -c /opt/wandbox/cattleshed/etc/cattleshed.conf \
        -c /opt/wandbox/cattleshed-conf/compilers.default &
      sleep 1
      /opt/wandbox/kennel/bin/kennel \
        -c /var/work/kennel.json &

      # wait forever
      while true; do
        sleep 10
      done
      "
elif [ "$1" = "test-client" ]; then
  docker run \
    --name test-client \
    --link test-server:test-server \
    -v `pwd`/..:/var/work \
    -v $BASE_DIR/../wandbox:/opt/wandbox \
    -it \
    melpon/wandbox:test-client \
    /bin/bash -c "
      cd /var/work/test
      exec /bin/bash
      # curl http://test-server:3500/api/list.json
    "
else
  exit 1
fi

