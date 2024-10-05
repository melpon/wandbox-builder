#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  exit 0
fi


git clone https://luajit.org/git/luajit.git
pushd luajit
  git checkout v$VERSION
popd

# build
pushd luajit
  make -j`nproc` PREFIX=$PREFIX
  make install PREFIX=$PREFIX
popd

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
