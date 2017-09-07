#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION="$1"
PREFIX="/opt/wandbox/crystal-$VERSION"

cd ~/

# get source
wget_strict_sha256 \
  "https://github.com/crystal-lang/crystal/archive/${VERSION}.tar.gz" \
  "$BASE_DIR/resources/${VERSION}.tar.gz.sha256"
tar xf "${VERSION}.tar.gz"

# build
cd "crystal-${VERSION}/"
make -j2 verbose=1

# install
mkdir -p "$PREFIX"
rm -rf "$PREFIX"/* "$PREFIX"/.[!.]*
cp -a ./. "$PREFIX"
