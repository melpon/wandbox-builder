#!/bin/bash

. ./init.sh

PREFIX=/opt/wandbox/swift-head

# get sources

mkdir ~/swift-source
cd ~/swift-source

git clone --depth 1 https://github.com/apple/swift.git

./swift/utils/update-checkout --clone

# build

cd swift
# utils/build-script --preset=buildbot_linux install_destdir=/opt/wandbox/swift-$VERSION installable_package=/root/test.tar.gz
#
# for 3.x
# utils/build-script --assertions --no-swift-stdlib-assertions --llbuild --swiftpm --xctest --build-subdir=buildbot_linux --lldb --release --test --validation-test --long-test --foundation --libdispatch --lit-args=-v -- --swift-enable-ast-verifier=0 --install-swift --install-lldb --install-llbuild --install-swiftpm --install-xctest --install-prefix=/usr '--swift-install-components=autolink-driver;compiler;clang-builtin-headers;stdlib;swift-remote-mirror;sdk-overlay;license' --build-swift-static-stdlib --build-swift-static-sdk-overlay --build-swift-stdlib-unittest-extra --test-installable-package --install-destdir=/opt/wandbox/swift-3.0.2 --installable-package=/root/test.tar.gz --install-foundation --install-libdispatch --reconfigure

utils/build-script \
  --assertions \
  --no-swift-stdlib-assertions \
  --build-subdir=buildbot_linux \
  --lldb \
  --release \
  --llbuild \
  --swiftpm \
  --xctest \
  --libdispatch \
  --foundation \
  --lit-args=-v \
  -- \
  --swift-enable-ast-verifier=0 \
  --install-swift \
  --install-lldb \
  --build-ninja \
  --install-llbuild \
  --install-swiftpm \
  --install-xctest \
  --install-libdispatch \
  --install-foundation \
  --build-swift-stdlib-unittest-extra \
  --build-swift-static-sdk-overlay \
  --jobs 2 \
  '--swift-install-components=autolink-driver;compiler;clang-builtin-headers;stdlib;swift-remote-mirror;sdk-overlay;license' \
  --build-swift-static-stdlib \
  --skip-test-lldb \
  --install-prefix=/usr \
  --install-destdir=$PREFIX \
  --reconfigure

# test

cd ~/
test_swift $PREFIX

rm -r ~/*
