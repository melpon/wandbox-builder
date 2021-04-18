#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION="$1"
PREFIX="/opt/wandbox/crystal-$VERSION"

cd /usr/local/

# prepare for bootstrapping
if compare_version "$VERSION" "<=" "0.23.1" ; then
  # Crystal 0.23.1 can't be compiled by Crystal >= 0.24.0 (melpon/wandbox-builder#17)
  archive="crystal-0.23.1-3-linux-x86_64.tar.gz"
  wget_strict_sha256 \
    "https://github.com/crystal-lang/crystal/releases/download/0.23.1/${archive}" \
    "$BASE_DIR/resources/${archive}.sha256"
  tar xf "./${archive}"
  rm "./${archive}"
  export PATH="/usr/local/crystal-0.23.1-3/bin/:$PATH"
fi
crystal --version

cd ~/

# get source
wget_strict_sha256 \
  "https://github.com/crystal-lang/crystal/archive/${VERSION}.tar.gz" \
  "$BASE_DIR/resources/${VERSION}.tar.gz.sha256"
tar xf "${VERSION}.tar.gz"

# build
cd "crystal-${VERSION}/"
make -j2 crystal verbose=1

# install
mkdir -p "$PREFIX"
rm -rf "$PREFIX"/* "$PREFIX"/.[!.]*
cp -a ./. "$PREFIX"
