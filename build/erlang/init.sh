#!/bin/bash

. ../init.sh

function test_erlang() {
  prefix=$1
  test "`$prefix/bin/escript $BASE_DIR/resources/test.erl`" = "hello"
}

function install_if_not_exists() {
  version=$1
  if [ ! -d /opt/wandbox/erlang-$version ]; then
    run_with_log 1 ./install.sh "$@"
  else
    echo "already installed erlang-$version"
  fi
}
