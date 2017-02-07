#!/bin/bash

. ../init.sh

function test_rust() {
  prefix=$1
  $prefix/bin/rustc $BASE_DIR/resources/test.rs && ./test > /dev/null && test "`./test`" = "hello" && rm test
}

function install_if_not_exists() {
  version=$1
  if [ ! -d /opt/wandbox/rust-$version ]; then
    run_with_log 1 ./install.sh "$@"
  else
    echo "already installed rust-$version"
  fi
}
