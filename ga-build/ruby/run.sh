#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  sudo apt-get install -y \
    libffi-dev \
    libgdbm-dev \
    libncurses5-dev \
    libreadline6-dev \
    libssl-dev \
    libyaml-dev
  exit 0
fi

SHORT_VERSION=$(echo "$VERSION" | sed -e 's/^\([0-9]\.[0-9]\).*$/\1/')

# get sources

curl_strict_sha256 \
  https://cache.ruby-lang.org/pub/ruby/$SHORT_VERSION/ruby-$VERSION.tar.gz \
  $BASE_DIR/resources/ruby-$VERSION.tar.gz.sha256
tar xf ruby-$VERSION.tar.gz

pushd ruby-$VERSION
  # build
  ./configure --disable-install-rdoc --disable-install-doc --prefix=$PREFIX
  make -j`nproc`
  make install
popd

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
