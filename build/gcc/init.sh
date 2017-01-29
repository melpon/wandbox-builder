#!/bin/bash

. ../init.sh

function test_gcc() {
  prefix=$1
  $prefix/bin/g++ $BASE_DIR/resources/test.cpp && ./a.out > /dev/null && test "`./a.out`" = "hello" && rm a.out
}

function install_if_not_exists() {
  version=$1
  if [ ! -d /opt/wandbox/gcc-$version ]; then
    run_with_log 1 ./install.sh "$@"
  else
    echo "already installed gcc-$version"
  fi
}
