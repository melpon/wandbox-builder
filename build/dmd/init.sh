#!/bin/bash

. ../init.sh

function test_dmd() {
  prefix=$1
  $prefix/linux/bin64/dmd $BASE_DIR/resources/test.d -ofa.out && ./a.out > /dev/null && test "`./a.out`" = "hello" && rm a.out
}

function install_if_not_exists() {
  version=$1
  if [ ! -d /opt/wandbox/dmd-$version ]; then
    run_with_log 1 ./install.sh "$@"
  else
    echo "already installed dmd-$version"
  fi
}
