#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  sudo apt-get install -y \
    libgmp-dev \
    xz-utils
  exit 0
fi

case $VERSION in
  "8.8.4" ) URL=https://downloads.haskell.org/~ghc/8.8.4/ghc-8.8.4-x86_64-deb9-linux.tar.xz ;;
  "8.10.4" ) URL=https://downloads.haskell.org/~ghc/8.10.4/ghc-8.10.4-x86_64-deb10-linux.tar.xz ;;
  "9.0.1" ) URL=https://downloads.haskell.org/~ghc/9.0.1/ghc-9.0.1-x86_64-deb10-linux.tar.xz ;;
  "9.10.1" ) URL=https://downloads.haskell.org/~ghc/9.10.1/ghc-9.10.1-x86_64-deb12-linux.tar.xz ;;
  * ) exit 1 ;;
esac

# get sources

FILENAME=${URL##*/}
curl_strict_sha256 \
  $URL \
  $BASE_DIR/resources/$FILENAME.sha256
tar xf $FILENAME

# install

# 9.10.1 ではディレクトリが ghc-9.10.1-x86_64-unknown-linux だった
pushd ghc-${VERSION} || pushd ghc-${VERSION}-x86_64-unknown-linux
  ./configure --prefix=$PREFIX
  make install
popd

rm -rf $PREFIX/share

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
