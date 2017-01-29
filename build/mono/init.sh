#!/bin/bash

. ../init.sh

function test_mono() {
  prefix=$1
  $prefix/bin/mcs $BASE_DIR/resources/test.cs -out:a.out && $prefix/bin/mono a.out > /dev/null && test "`$prefix/bin/mono a.out`" = "hello" && rm a.out
}

function install_if_not_exists() {
  version=$1
  if [ ! -d /opt/wandbox/mono-$version ]; then
    run_with_log 1 ./install.sh "$@"
  else
    echo "already installed mono-$version"
  fi
}
