#!/bin/bash

. ../init.sh

function test_perl() {
  prefix=$1
  test "`$prefix/bin/perl $BASE_DIR/resources/test.pl`" = "hello"
}

function install_if_not_exists() {
  version=$1
  if [ ! -d /opt/wandbox/perl-$version ]; then
    run_with_log 1 ./install.sh "$@"
  else
    echo "already installed perl-$version"
  fi
}
