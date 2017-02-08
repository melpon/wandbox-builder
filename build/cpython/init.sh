#!/bin/bash

. ../init.sh

function test_cpython() {
  python=$1
  $python $BASE_DIR/resources/test.py > /dev/null && test "`$python $BASE_DIR/resources/test.py`" = "hello"
}

function install_if_not_exists() {
  version=$1
  if [ ! -d /opt/wandbox/cpython-$version ]; then
    run_with_log 1 ./install.sh "$@"
  else
    echo "already installed cpython-$version"
  fi
}
