#!/bin/bash

. ../init.sh

function test_coffeescript() {
  prefix=$1
  test "`$prefix/bin/run-coffee.sh $BASE_DIR/resources/test.coffee`" = "hello"
}

function install_if_not_exists() {
  version=$1
  if [ ! -d /opt/wandbox/coffeescript-$version ]; then
    run_with_log 1 ./install.sh "$@"
  else
    echo "already installed coffeescript-$version"
  fi
}
