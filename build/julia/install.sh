#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
MAJOR_MINOR=${1%.*}
PREFIX=/opt/wandbox/julia-$VERSION

cd ~/
wget_strict_sha256 \
  https://julialang-s3.julialang.org/bin/linux/x64/$MAJOR_MINOR/julia-$VERSION-linux-x86_64.tar.gz \
  $BASE_DIR/resources/julia-$VERSION.sha256

tar xf julia-$VERSION-linux-x86_64.tar.gz

rm -rf $PREFIX || true
mv julia-$VERSION $PREFIX
