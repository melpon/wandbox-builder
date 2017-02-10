#!/bin/bash

. ../init.sh

function test_scala() {
  prefix=$1
  pushd $BASE_DIR/resources
  $prefix/bin/run-scalac.sh test.scala && test "`$prefix/bin/run-scala.sh`" = "hello" && rm *.class
  popd
}

function install_if_not_exists() {
  version=$1
  if [ ! -d /opt/wandbox/scala-$version ]; then
    run_with_log 1 ./install.sh "$@"
  else
    echo "already installed scala-$version"
  fi
}
