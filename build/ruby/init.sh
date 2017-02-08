#!/bin/bash

. ../init.sh

function test_ruby() {
  prefix=$1
  $prefix/bin/ruby $BASE_DIR/resources/test.rb > /dev/null && test "`$prefix/bin/ruby $BASE_DIR/resources/test.rb`" = "hello"
}

function install_if_not_exists() {
  version=$1
  if [ ! -d /opt/wandbox/ruby-$version ]; then
    run_with_log 1 ./install.sh "$@"
  else
    echo "already installed ruby-$version"
  fi
}
