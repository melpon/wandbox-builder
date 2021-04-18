#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  sudo apt-get install -y \
    libssl-dev \
    ninja-build \
    pkg-config
  exit 0
fi

git clone --depth 1 --branch $VERSION https://github.com/rust-lang/rust.git

pushd rust
  # build
  ./configure --prefix=$PREFIX
  make -j`nproc`
  make install
popd

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
