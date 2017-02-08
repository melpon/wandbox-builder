#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)

if [ $# -lt 1 ]; then
    echo "usage:"
    echo "  $0 test1 [test2 [test3 [...]]]"
    echo "  $0 --all"
    echo ""
    echo "example:"
    echo "  $0 'gcc-head'"
    echo "  $0 'clang-*'"
    echo "  $0 'boost-*-gcc-*' 'boost-1.6?.0-clang-*'"
    exit 0
fi

../build/docker-rm.sh > /dev/null 2>&1

# run test-server
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

# run test-client
docker run \
  --name test-client \
  --link test-server:test-server \
  -v `pwd`/..:/var/work \
  -v $BASE_DIR/../wandbox:/opt/wandbox \
  -it \
  melpon/wandbox:test-client \
  /bin/bash -c "
    cd /var/work/test
    echo 'wait: kennel port...'
    # wait until kennel port is opened
    for ((i = 0; i < 20; i++)); do
      if curl http://test-server:3500/api/list.json > /dev/null 2>&1; then
        echo 'opened'
        python run.py \"\$@\"
        exit \$?
      else
        sleep 1
      fi
    done
    echo 'timeout: kennel port is not opened'
    exit 1
  " $0 "$@"

docker logs test-server
docker stop test-server

../build/docker-rm.sh
