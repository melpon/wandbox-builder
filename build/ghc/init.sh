#!/bin/bash

. ../init.sh

function test_ghc() {
  prefix=$1
  $prefix/bin/ghc $BASE_DIR/resources/test.hs -o a.out && ./a.out > /dev/null && test "`./a.out`" = "hello" && rm a.out
}

function install_if_not_exists() {
  version=$1
  if [ ! -d /opt/wandbox/ghc-$version ]; then
    run_with_log 1 ./install.sh "$@"
  else
    echo "already installed ghc-$version"
  fi
}
