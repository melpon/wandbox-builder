#!/bin/bash

set -ex

BASE_DIR=$(cd $(dirname $0); pwd)/build
cd $BASE_DIR

for compiler in \
    gcc-head \
    clang-head \
    mono-head \
    boost-head \
    rill-head \
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

# copy static files
mkdir wandbox/static || true
cp -r static/ wandbox/static/

# header only library
rm -rf wandbox/sprout || true
git clone --depth 1 https://github.com/bolero-MURAKAMI/Sprout.git wandbox/sprout
rm -rf wandbox/range-v3 || true
git clone --depth 1 https://github.com/ericniebler/range-v3.git wandbox/range-v3
rm -rf wandbox/boost-sml || true
git clone --depth 1 https://github.com/boost-experimental/sml.git wandbox/boost-sml
rm -rf wandbox/msgpack-c || true
git clone --depth 1 https://github.com/msgpack/msgpack-c.git wandbox/msgpack-c

# change owner to root
docker run --net=host -i -v $BASE_DIR/../wandbox:/opt/wandbox ubuntu:16.04 /bin/bash -c "
  set -ex
  chown -R root:root /opt/wandbox/static
  chown -R root:root /opt/wandbox/sprout
  chown -R root:root /opt/wandbox/range-v3
  chown -R root:root /opt/wandbox/boost-sml
  chown -R root:root /opt/wandbox/msgpack-c
"

./docker-rm.sh

cd ..

./sync.sh cattleshed-root
