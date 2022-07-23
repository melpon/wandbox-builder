#!/bin/bash

set -ex

PREFIX=/opt/wandbox/zig-head

TARBALL=`curl -L https://ziglang.org/download/index.json | jq -r '.master."x86_64-linux".tarball'`
SHASUM=`curl -L https://ziglang.org/download/index.json | jq -r '.master."x86_64-linux".shasum'`

curl -LO $TARBALL

TARNAME=`basename $TARBALL`
DIRNAME=`basename -s '.tar.xz' $TARNAME`

echo "$SHASUM *$TARNAME" | sha256sum -c

tar xf $TARNAME

mkdir -p `dirname $PREFIX`
cp -r $DIRNAME $PREFIX