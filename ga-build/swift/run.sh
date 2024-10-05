#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

BOOTSTRAP_SWIFT_VERSION="5.10.1"

if [ "$SUBCOMMAND" == "setup" ]; then
  # https://github.com/apple/swift/blob/main/docs/HowToGuides/GettingStarted.md#ubuntu-linux
  # https://www.swift.org/install/linux/tarball/
  # より
  sudo apt-get install -y \
    binutils              \
    clang                 \
    cmake                 \
    git                   \
    gnupg2                \
    icu-devtools          \
    libc6-dev             \
    libcurl4-openssl-dev  \
    libedit-dev           \
    libedit2              \
    libgcc-13-dev         \
    libicu-dev            \
    libncurses-dev        \
    libpython3-dev        \
    libpython3-dev        \
    libsqlite3-dev        \
    libstdc++-13-dev      \
    libxml2-dev           \
    libz3-dev             \
    ninja-build           \
    pkg-config            \
    python3               \
    rsync                 \
    swig                  \
    systemtap-sdt-dev     \
    tzdata                \
    unzip                 \
    uuid-dev              \
    zlib1g-dev

  # ブートストラップ用の Swift
  curl_strict_sha256 \
    https://download.swift.org/swift-${BOOTSTRAP_SWIFT_VERSION}-release/ubuntu2404/swift-${BOOTSTRAP_SWIFT_VERSION}-RELEASE/swift-${BOOTSTRAP_SWIFT_VERSION}-RELEASE-ubuntu24.04.tar.gz \
    $BASE_DIR/resources/swift-${BOOTSTRAP_SWIFT_VERSION}-RELEASE-ubuntu24.04.tar.gz
  tar xf swift-${BOOTSTRAP_SWIFT_VERSION}-RELEASE-ubuntu24.04.tar.gz

  exit 0
fi

export PATH=`pwd`/swift-${BOOTSTRAP_SWIFT_VERSION}-RELEASE-ubuntu24.04/usr/bin:$PATH

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
    --swift-darwin-supported-archs=`uname -m` \
    --install-swift \
    --install-lldb \
    --install-destdir=$PREFIX \
    --install-prefix=$PREFIX
popd

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
