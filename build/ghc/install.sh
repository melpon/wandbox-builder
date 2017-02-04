#!/bin/bash

. ./init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/ghc-$VERSION

case $VERSION in
  "7.6.3" ) URL="https://www.haskell.org/ghc/dist/7.6.3/ghc-7.6.3-x86_64-unknown-linux.tar.bz2" ;;
  "7.8.3" ) URL="https://www.haskell.org/ghc/dist/7.8.3/ghc-7.8.3-x86_64-unknown-linux-deb7.tar.bz2" ;;
  "7.10.3" ) URL="http://downloads.haskell.org/~ghc/7.10.3/ghc-7.10.3b-x86_64-deb8-linux.tar.bz2" ;;
  "8.0.2" ) URL="http://downloads.haskell.org/~ghc/8.0.2/ghc-8.0.2-x86_64-deb8-linux.tar.xz" ;;
  * ) exit 1 ;;
esac

# get sources

cd ~/

wget $URL
FILENAME=${URL##*/}
tar xf $FILENAME

# install

cd ghc-${VERSION}
./configure --prefix=$PREFIX

make install
rm -r $PREFIX/share

# cleanup

cd ~/
rm -r ~/*

test_ghc $PREFIX
