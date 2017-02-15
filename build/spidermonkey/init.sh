#!/bin/bash

. ../init.sh

function test_spidermonkey() {
  prefix=$1
  test "`$prefix/bin/js $BASE_DIR/resources/test.js`" = "hello"
}

function install_if_not_exists() {
  version=$1
  if [ ! -d /opt/wandbox/spidermonkey-$version ]; then
    run_with_log 1 ./install.sh "$@"
  else
    echo "already installed spidermonkey-$version"
  fi
}
