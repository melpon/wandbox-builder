#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/zapcc-$VERSION

case "$VERSION" in
  "1.0.1" ) ;;
  "2017.08" ) RESOURCE_NAME="20170802-175507" ;;
  * ) exit 1 ;;
esac

# extract

cd ~/

if [ "$VERSION" = "1.0.1" ]; then
  mkdir zapcc-$VERSION
  cd zapcc-$VERSION
  tar xf $BASE_DIR/resources/zapcc-$VERSION.tar.gz --strip-component=1
  cd ..
else
  cp $BASE_DIR/resources/zapcc-$RESOURCE_NAME.7z ./
  7zr x zapcc-$RESOURCE_NAME.7z
  mv zapcc-$RESOURCE_NAME zapcc-$VERSION
fi

# install

rm -r $PREFIX || true
cp -r ~/zapcc-$VERSION $PREFIX

# add license

cp $BASE_DIR/resources/zapcc-key.txt $PREFIX/bin
