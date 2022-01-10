#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s - -y
  sudo apt-get install -y \
    pkg-config \
    python3-distutils
  exit 0
fi

PATH="$HOME/.cargo/bin:$PATH"

case "$VERSION" in
  "88.0.0" ) URL=https://firefox-ci-tc.services.mozilla.com/api/queue/v1/task/QLT2GQCkRTunGRW6ryH7tQ/runs/0/artifacts/public/build/mozjs-88.0.0.tar.xz ;;
  * ) exit 1 ;;
esac

curl_strict_sha256 \
  $URL \
  $BASE_DIR/resources/mozjs-$VERSION.tar.xz.sha256
mkdir mozjs-$VERSION
tar xf mozjs-$VERSION.tar.xz -C mozjs-$VERSION --strip-components=1

pushd mozjs-$VERSION/js/src
  mkdir build_OPT.OBJ
  pushd build_OPT.OBJ
    SHELL=/bin/bash ../configure --prefix=$PREFIX --disable-shared-js
    make -j`nproc`
    make install
  popd
popd

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
