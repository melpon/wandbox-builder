#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  sudo apt-get install -y \
    python3-distutils \
    python3-minimal \
    python2-minimal
  exit 0
fi

# get sources

wget_strict_sha256 \
  https://nodejs.org/dist/v$VERSION/node-v$VERSION.tar.gz \
  $BASE_DIR/resources/node-v$VERSION.tar.gz.sha256

tar xf node-v$VERSION.tar.gz
pushd node-v$VERSION
  # build
  ./configure --prefix=$PREFIX --partly-static
  make -j`nproc`
  make install

  # update
  PATH=$PREFIX/bin:$PATH npm update -g
popd

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
