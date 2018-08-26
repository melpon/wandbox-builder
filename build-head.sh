#!/bin/bash

if [ $# -lt 1 ]; then
  echo "$0 <remote-host>"
  echo ""
  echo "example:"
  echo "  $0 username@example.com"
  echo "  $0 melpon-builder"
  exit 1
fi

CURRENT_DIR=$(cd $(dirname $0); pwd)

if [ -e $CURRENT_DIR/build-head.lock ]; then
  echo "$0 already running - the file $CURRENT_DIR/build-head.lock exists"
  exit 1
fi
touch build-head.lock
trap "rm $CURRENT_DIR/build-head.lock > /dev/null 2>&1" EXIT

set -ex
STARTED_AT="`date --iso-8601=seconds`"

REMOTE_HOST=$1

LOG_DIR=$CURRENT_DIR/build-head
CONTAINER_LOG_DIR=/var/work/build-head
if [ -d $LOG_DIR ]; then
  docker run -i -v $CURRENT_DIR:/var/work ubuntu:16.04 rm -r $CONTAINER_LOG_DIR.yesterday
  cp -r $LOG_DIR $LOG_DIR.yesterday
  docker run -i -v $CURRENT_DIR:/var/work ubuntu:16.04 rm -r $CONTAINER_LOG_DIR
fi
mkdir $LOG_DIR

BASE_DIR=$(cd $(dirname $0); pwd)/build
cd $BASE_DIR

function run() {
  compiler=$1
  if [ "$compiler" = "boost-head" -o \
       "$compiler" = "cpython-head" -o \
       "$compiler" = "scala-head" ]; then
    cat $compiler/VERSIONS | while read line; do
      if [ "$line" != "" ]; then
        COMMAND="cd /var/work/$compiler && ./install.sh $line"
        TEST_COMMAND="cd /var/work/$compiler && ../test-all.sh $compiler"
        docker run --net=host -i -v $BASE_DIR:/var/work -v $BASE_DIR/../wandbox:/opt/wandbox melpon/wandbox:$compiler /bin/bash -c "$COMMAND" || return $?
        docker run --net=host -i -v $BASE_DIR:/var/work -v $BASE_DIR/../wandbox:/opt/wandbox melpon/wandbox:test-server /bin/bash -c "$TEST_COMMAND" || return $?
      fi
    done
  else
    COMMAND="cd /var/work/$compiler && exec ./install.sh"
    TEST_COMMAND="cd /var/work/$compiler && exec ./test.sh"
    docker run --net=host -i -v $BASE_DIR:/var/work -v $BASE_DIR/../wandbox:/opt/wandbox melpon/wandbox:$compiler /bin/bash -c "$COMMAND" || return $?
    docker run --net=host -i -v $BASE_DIR:/var/work -v $BASE_DIR/../wandbox:/opt/wandbox melpon/wandbox:test-server /bin/bash -c "$TEST_COMMAND" || return $?
  fi
}

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
    ldc-head \
    dmd-head \
    openjdk-head \
    cpython-head \
    ruby-head \
    mruby-head \
    scala-head \
    nodejs-head \
    coffeescript-head \
    swift-head \
    perl-head \
    php-head \
    sqlite-head \
    fpc-head \
    vim-head \
    pypy-head \
    ocaml-head \
    go-head \
    sbcl-head \
    pony-head \
    nim-head \
    openssl-head \
    rust-head \
    luajit-head \
    fsharp-head \
    cmake-head \
    dotnetcore-head \
; do
  # remove groovy-head for out of memory
  # groovy-head

  start_time=`date +%s`

  run $compiler > $LOG_DIR/$compiler.log 2>&1 || echo "$compiler: $?" >> $LOG_DIR/failed.log

  end_time=`date +%s`
  ss=`expr ${end_time} - ${start_time} || true`
  hh=`expr ${ss} / 3600 || true`
  ss=`expr ${ss} % 3600 || true`
  mm=`expr ${ss} / 60 || true`
  ss=`expr ${ss} % 60 || true`
  echo "$compiler: `printf %02d:%02d:%02d $hh $mm $ss`" >> $LOG_DIR/time.log

  $BASE_DIR/docker-rm.sh
done

BUILDING_FINISHED_AT="`date --iso-8601=seconds`"

cd ..

# change owner to root
docker run --net=host -i -v `pwd`:/var/work -v $BASE_DIR/../wandbox:/opt/wandbox ubuntu:16.04 /bin/bash -c "
  set -ex
  apt-get update && apt-get install -y git

  cd /var/work

  # copy static files
  mkdir /opt/wandbox/static || true
  cp -r static/* wandbox/static/

  # header only library
  rm -rf /opt/wandbox/sprout || true
  git clone --depth 1 https://github.com/bolero-MURAKAMI/Sprout.git /opt/wandbox/sprout
  rm -rf /opt/wandbox/range-v3 || true
  git clone --depth 1 https://github.com/ericniebler/range-v3.git /opt/wandbox/range-v3
  rm -rf /opt/wandbox/boost-sml || true
  git clone --depth 1 https://github.com/boost-experimental/sml.git /opt/wandbox/boost-sml
  rm -rf /opt/wandbox/msgpack-c || true
  git clone --depth 1 https://github.com/msgpack/msgpack-c.git /opt/wandbox/msgpack-c
  rm -rf /opt/wandbox/boost-di || true
  git clone --depth 1 https://github.com/boost-experimental/di.git /opt/wandbox/boost-di
  rm -rf /opt/wandbox/nlohmann-json || true
  git clone --depth 1 https://github.com/nlohmann/json.git /opt/wandbox/nlohmann-json
  rm -rf /opt/wandbox/cmcstl2 || true
  git clone --depth 1 https://github.com/CaseyCarter/cmcstl2.git /opt/wandbox/cmcstl2
  rm -rf /opt/wandbox/te || true
  git clone --depth 1 https://github.com/boost-experimental/te.git /opt/wandbox/te
"

./build/docker-rm.sh

./sync.sh $REMOTE_HOST --all || true

ALL_FINISHED_AT="`date --iso-8601=seconds`"

echo "started at $STARTED_AT"
echo "building finished at $BUILDING_FINISHED_AT"
echo "all finished at $ALL_FINISHED_AT"
