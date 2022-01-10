#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  exit 0
fi


# get sources
# https://www.sqlite.org/chronology.html から探す
case "$VERSION" in
  "3.35.5" ) YEAR=2021; NUMVER=3350500 ;;
  * ) exit 1
esac

curl_strict_sha256 \
  http://www.sqlite.org/$YEAR/sqlite-autoconf-$NUMVER.tar.gz \
  $BASE_DIR/resources/sqlite-autoconf-$NUMVER.tar.gz.sha256

tar xf sqlite-autoconf-$NUMVER.tar.gz

pushd sqlite-autoconf-$NUMVER
  # build
  ./configure --prefix=$PREFIX
  make -j`nproc`
  make install
popd

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
