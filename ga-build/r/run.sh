#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  sudo apt-get install -y \
    gfortran \
    libbz2-dev \
    liblzma-dev \
    libpcre2-dev \
    libpcre3-dev \
    libcurl4-openssl-dev
  exit 0
fi

MAJOR_VERSION=${VERSION:0:1}
curl_strict_sha256 \
  https://cran.r-project.org/src/base/R-${MAJOR_VERSION}/R-$VERSION.tar.gz \
  $BASE_DIR/resources/R-$VERSION.tar.gz.sha256

tar xf R-$VERSION.tar.gz

pushd R-$VERSION
  # build
  ./configure --prefix=$PREFIX --without-readline --without-x
  make -j`nproc`
  make install
popd

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
