#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  sudo apt-get install -y \
    libncurses5-dev \
    libpcre2-dev \
    libssl-dev \
    zlib1g-dev
  exit 0
fi

# get sources
git clone --depth 1 -b $VERSION https://github.com/ponylang/ponyc.git

# build
pushd ponyc
  make libs build_flags="-j`nproc`"
  make configure
  make build
  make prefix=$PREFIX install
popd

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
