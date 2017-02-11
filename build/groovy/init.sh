#!/bin/bash

. ../init.sh

function test_groovy() {
  prefix=$1
  test "`$prefix/bin/run-groovy.sh $BASE_DIR/resources/test.groovy`" = "hello"
}

function install_if_not_exists() {
  version=$1
  if [ ! -d /opt/wandbox/groovy-$version ]; then
    run_with_log 1 ./install.sh "$@"
  else
    echo "already installed groovy-$version"
  fi
}
