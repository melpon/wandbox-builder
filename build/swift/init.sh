#!/bin/bash

. ../init.sh

function test_swift() {
  prefix=$1
  $prefix/usr/bin/swiftc $BASE_DIR/resources/test.swift && ./test > /dev/null && test "`./test`" = "hello" && rm test
}

function install_if_not_exists() {
  version=$1
  if [ ! -d /opt/wandbox/swift-$version ]; then
    run_with_log 1 ./install.sh "$@"
  else
    echo "already installed swift-$version"
  fi
}
