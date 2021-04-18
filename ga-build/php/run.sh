#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  sudo apt-get install -y \
    bison \
    libonig-dev \
    libsqlite3-dev \
    libxml2-dev \
    pkg-config \
    re2c
  exit 0
fi

# get sources

curl_strict_sha256 \
  http://php.net/get/php-$VERSION.tar.gz/from/this/mirror \
  $BASE_DIR/resources/php-$VERSION.tar.gz.sha256 \
  php-$VERSION.tar.gz

tar xf php-$VERSION.tar.gz

pushd php-$VERSION
  # build
  ./configure \
    --prefix=$PREFIX \
    --enable-mbstring \
    --disable-libxml \
    --disable-dom \
    --disable-simplexml \
    --disable-xml \
    --disable-xmlreader \
    --disable-xmlwriter \
    --without-pear \
    --disable-opcache

  make -j`nproc`
  make install
popd

cp $BASE_DIR/resources/php.ini $PREFIX/lib

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
