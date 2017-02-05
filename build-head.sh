#!/bin/bash

if [ $# -lt 1 ]; then
  echo "$0 <remote-host>"
  echo ""
  echo "example:"
  echo "  $0 username@example.com"
  echo "  $0 melpon-builder"
  exit 1
fi

set -ex

REMOTE_HOST=$1

BASE_DIR=$(cd $(dirname $0); pwd)/build
cd $BASE_DIR

for compiler in \
    gcc-head \
    clang-head \
    mono-head \
    boost-head \
    rill-head \
    erlang-head \
    elixir-head \
    ghc-head \
    gdc-head \
    dmd-head \
; do
  if [ "$compiler" = "boost-head" ]; then
    cat $compiler/VERSIONS | while read line; do
      if [ "$line" != "" ]; then
        COMMAND="cd /var/work/$compiler && ./install.sh $line"
        docker run --net=host -i -v $BASE_DIR:/var/work -v $BASE_DIR/../wandbox:/opt/wandbox melpon/wandbox:$compiler /bin/bash -c "$COMMAND"
      fi
    done
  else
    COMMAND="cd /var/work/$compiler && exec ./install.sh"
    docker run --net=host -i -v $BASE_DIR:/var/work -v $BASE_DIR/../wandbox:/opt/wandbox melpon/wandbox:$compiler /bin/bash -c "$COMMAND"
  fi
done

cd ..

# change owner to root
docker run --net=host -i -v `pwd`:/var/work -v $BASE_DIR/../wandbox:/opt/wandbox ubuntu:16.04 /bin/bash -c "
  set -ex
  apt-get update && apt-get install -y git

  cd /var/work

  # copy static files
  mkdir /opt/wandbox/static || true
  cp -r static/ wandbox/static/

  # header only library
  rm -rf /opt/wandbox/sprout || true
  git clone --depth 1 https://github.com/bolero-MURAKAMI/Sprout.git /opt/wandbox/sprout
  rm -rf /opt/wandbox/range-v3 || true
  git clone --depth 1 https://github.com/ericniebler/range-v3.git /opt/wandbox/range-v3
  rm -rf /opt/wandbox/boost-sml || true
  git clone --depth 1 https://github.com/boost-experimental/sml.git /opt/wandbox/boost-sml
  rm -rf /opt/wandbox/msgpack-c || true
  git clone --depth 1 https://github.com/msgpack/msgpack-c.git /opt/wandbox/msgpack-c
"

./build/docker-rm.sh

./sync.sh $REMOTE_HOST --all
