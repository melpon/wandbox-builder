#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

BOOTSTRAP_SWIFT_VERSION="5.10.1"

if [ "$SUBCOMMAND" == "setup" ]; then
  # https://github.com/swiftlang/swift-docker/blob/1c187af5052cbc582596c01de93e2d8f66187fd7/swift-ci/main/ubuntu/24.04/Dockerfile
  sudo apt-get install -y \
    build-essential       \
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
    python3-six           \
    python3-pip           \
    python3-pkg-resources \
    python3-psutil        \
    python3-setuptools    \
    rsync                 \
    swig                  \
    systemtap-sdt-dev     \
    tzdata                \
    uuid-dev              \
    zip

  # ブートストラップ用の Swift
  curl_strict_sha256 \
    https://download.swift.org/swift-${BOOTSTRAP_SWIFT_VERSION}-release/ubuntu2404/swift-${BOOTSTRAP_SWIFT_VERSION}-RELEASE/swift-${BOOTSTRAP_SWIFT_VERSION}-RELEASE-ubuntu24.04.tar.gz \
    $BASE_DIR/resources/swift-${BOOTSTRAP_SWIFT_VERSION}-RELEASE-ubuntu24.04.tar.gz.sha256
  tar xf swift-${BOOTSTRAP_SWIFT_VERSION}-RELEASE-ubuntu24.04.tar.gz -C ~/

  exit 0
fi

export PATH=~/swift-${BOOTSTRAP_SWIFT_VERSION}-RELEASE-ubuntu24.04/usr/bin:$PATH

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
