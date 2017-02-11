#!/bin/bash

. ../init.sh

function test_nodejs() {
  prefix=$1
  test "`$prefix/bin/node $BASE_DIR/resources/test.js`" = "hello"
}

function install_if_not_exists() {
  version=$1
  if [ ! -d /opt/wandbox/nodejs-$version ]; then
    run_with_log 1 ./install.sh "$@"
  else
    echo "already installed nodejs-$version"
  fi
}
