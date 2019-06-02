#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/swift-$VERSION

# get sources

mkdir ~/swift-source
cd ~/swift-source

git clone --depth 1 --branch swift-${VERSION}-RELEASE https://github.com/apple/swift.git

if compare_version "$VERSION" ">=" "3.0"; then
  if [ -f swift/utils/update-checkout-config.json ]; then
    $BASE_DIR/resources/clone-all swift/utils/update-checkout-config.json swift-${VERSION}-RELEASE
  else
    $BASE_DIR/resources/clone-all swift/utils/update_checkout/update-checkout-config.json swift-${VERSION}-RELEASE
  fi
else
  $BASE_DIR/resources/clone-all-2.x swift-${VERSION}-RELEASE
fi

if [ ! -d ninja ]; then
  git clone --depth 1 --branch release https://github.com/ninja-build/ninja.git
fi

# build

cd swift
# utils/build-script --preset=buildbot_linux install_destdir=/opt/wandbox/swift-$VERSION installable_package=/root/test.tar.gz
#
# for 3.x
# utils/build-script --assertions --no-swift-stdlib-assertions --llbuild --swiftpm --xctest --build-subdir=buildbot_linux --lldb --release --test --validation-test --long-test --foundation --libdispatch --lit-args=-v -- --swift-enable-ast-verifier=0 --install-swift --install-lldb --install-llbuild --install-swiftpm --install-xctest --install-prefix=/usr '--swift-install-components=autolink-driver;compiler;clang-builtin-headers;stdlib;swift-remote-mirror;sdk-overlay;license' --build-swift-static-stdlib --build-swift-static-sdk-overlay --build-swift-stdlib-unittest-extra --test-installable-package --install-destdir=/opt/wandbox/swift-3.0.2 --installable-package=/root/test.tar.gz --install-foundation --install-libdispatch --reconfigure
#
# for 2.x
# utils/build-script --assertions --no-swift-stdlib-assertions --build-subdir=buildbot_linux --lldb --release --test --validation-test -- --swift-enable-ast-verifier=0 --install-swift --install-lldb --install-prefix=/usr '--swift-install-components=compiler;clang-builtin-headers;stdlib;sdk-overlay;license' --build-swift-static-stdlib=1 --skip-test-lldb=1 --test-installable-package=1 --install-destdir=/opt/wandbox/swift- --installable-package=/root/test.tar.gz --reconfigure


if compare_version "$VERSION" ">=" "3.0"; then
  FLAGS=" \
    --llbuild \
    --swiftpm \
    --xctest \
    --libdispatch \
    --foundation \
    --lit-args=-v \
    "
  FLAGS_IMPL=" \
    --build-ninja \
    --install-llbuild \
    --install-swiftpm \
    --install-xctest \
    --install-libdispatch \
    --install-foundation \
    --build-swift-stdlib-unittest-extra \
    --build-swift-static-sdk-overlay \
    --jobs 2 \
    --swift-install-components=autolink-driver;compiler;clang-builtin-headers;stdlib;swift-remote-mirror;sdk-overlay;license \
    --build-swift-static-stdlib \
    --skip-test-lldb \
    "
else
  FLAGS=""
  FLAGS_IMPL=" \
    --swift-install-components=compiler;clang-builtin-headers;stdlib;sdk-overlay;license \
    --build-swift-static-stdlib=1 \
    --skip-test-lldb=1 \
    "
fi

utils/build-script \
  --assertions \
  --no-swift-stdlib-assertions \
  --build-subdir=buildbot_linux \
  --lldb \
  --release \
  $FLAGS \
  -- \
  --swift-enable-ast-verifier=0 \
  --install-swift \
  --install-lldb \
  $FLAGS_IMPL \
  --install-prefix=/usr \
  --install-destdir=$PREFIX \
  --reconfigure

# test

rm -r ~/*
