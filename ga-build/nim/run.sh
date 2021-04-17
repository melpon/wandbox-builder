#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  sudo apt-get install -y \
    libncurses5-dev \
    libpcre2-dev \
    libssl-dev
  exit 0
fi

# ==== get sources ====
curl_strict_sha256 \
  https://github.com/nim-lang/Nim/archive/v$VERSION.tar.gz \
  $BASE_DIR/resources/Nim-$VERSION.tar.gz.sha256 \
  Nim-$VERSION.tar.gz

mkdir -p Nim-$VERSION
pushd Nim-$VERSION
  tar xf ../Nim-$VERSION.tar.gz --strip-component 1

  # ==== build ====
  sh build_all.sh

  # ==== install ====
  ./koch install /opt
  mkdir -p `dirname $PREFIX`
  mv /opt/nim "$PREFIX"
popd

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
