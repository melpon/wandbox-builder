#!/bin/bash

. ../init.sh

function test_elixir() {
  prefix=$1
  test "`$prefix/bin/run-elixir.sh $BASE_DIR/resources/test.exs`" = "hello"
}

function install_if_not_exists() {
  version=$1
  if [ ! -d /opt/wandbox/elixir-$version ]; then
    run_with_log 1 ./install.sh "$@"
  else
    echo "already installed elixir-$version"
  fi
}
