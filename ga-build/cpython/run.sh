#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  apt-get install -y \
    libc6-dev \
    libffi-dev \
    libgdbm-dev \
    libncursesw5-dev \
    libsqlite3-dev \
    libssl-dev \
    python3-minimal \
    tk-dev \
    zlib1g-dev
  exit 0
fi

# get sources

git clone --depth 1 --branch v$VERSION https://github.com/python/cpython.git
cd cpython

# build

./configure --enable-optimizations --prefix=$PREFIX
make -j`nproc`
make install

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
