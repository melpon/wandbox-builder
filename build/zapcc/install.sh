#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/zapcc-$VERSION

# extract

cd ~/
mkdir zapcc-$VERSION
cd zapcc-$VERSION
tar xf $BASE_DIR/resources/zapcc-$VERSION.tar.gz --strip-component=1
cd ..

# install

rm -r $PREFIX || true
cp -r ~/zapcc-$VERSION $PREFIX

# add license

#cp $BASE_DIR/resources/zapcc-key.txt $PREFIX/bin
