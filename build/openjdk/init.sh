#!/bin/bash

. ../init.sh

function test_openjdk() {
  prefix=$1
  pushd $BASE_DIR/resources
  $prefix/bin/javac test.java && test "`$prefix/bin/run-java.sh`" = "hello" && rm test.class
  popd
}

function install_if_not_exists() {
  version=$1
  if [ ! -d /opt/wandbox/openjdk-$version ]; then
    run_with_log 1 ./install.sh "$@"
  else
    echo "already installed openjdk-$version"
  fi
}
