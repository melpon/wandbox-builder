#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  # https://github.com/apple/swift/blob/main/docs/HowToGuides/GettingStarted.md#ubuntu-linux より
  sudo apt-get install -y \
    clang                 \
    cmake                 \
    git                   \
    icu-devtools          \
    libcurl4-openssl-dev  \
    libedit-dev           \
    libicu-dev            \
    libncurses5-dev       \
    libpython3-dev        \
    libsqlite3-dev        \
    libxml2-dev           \
    ninja-build           \
    pkg-config            \
    python3               \
    rsync                 \
    swig                  \
    systemtap-sdt-dev     \
    tzdata                \
    uuid-dev
  exit 0
fi

git clone https://github.com/apple/swift.git
pushd swift
  git reset --hard swift-${VERSION}-RELEASE
  utils/update-checkout --clone --tag swift-${VERSION}-RELEASE
popd

pushd swift
  utils/build-script \
    --release \
    --skip-build-benchmarks \
    --skip-ios \
    --skip-watchos \
    --skip-tvos \
    --install-swift \
    --install-lldb \
    --swift-darwin-supported-archs=`uname -m` \
    --install-destdir=$PREFIX \
    --install-prefix=$PREFIX \
popd

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
