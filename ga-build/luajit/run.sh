#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  exit 0
fi


wget_strict_sha256 \
  http://luajit.org/download/LuaJIT-$VERSION.tar.gz \
  $BASE_DIR/resources/LuaJIT-$VERSION.tar.gz.sha256

tar xf LuaJIT-$VERSION.tar.gz

# build
pushd LuaJIT-$VERSION
  make -j`nproc` PREFIX=$PREFIX
  make install PREFIX=$PREFIX
popd

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
