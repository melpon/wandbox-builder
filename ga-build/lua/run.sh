#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  sudo apt-get install -y \
    libncurses5-dev \
    libreadline6-dev
  exit 0
fi

# get sources

wget_strict_sha256 \
  http://www.lua.org/ftp/lua-$VERSION.tar.gz \
  $BASE_DIR/resources/lua-$VERSION.tar.gz.sha256

tar xf lua-$VERSION.tar.gz

# build
pushd lua-$VERSION
  sed -i -e "s|^INSTALL_TOP=.*|INSTALL_TOP=$PREFIX|" Makefile
  make -j`nproc` linux
  make install
popd

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
