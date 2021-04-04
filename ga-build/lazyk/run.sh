#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  exit 0
fi

mkdir -p $PREFIX/bin
g++ $BASE_DIR/resources/lazy.cpp -O2 -o $PREFIX/bin/lazyk

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
