#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  exit 0
fi

# devel version
case "$VERSION" in
  5.25* | \
  5.27* | \
  5.29* | \
  5.31* | \
  5.33* | \
  5.35* | \
  5.37* | \
  5.39* | \
  5.41* | \
  5.43* | \
  5.45* | \
  5.47* | \
  5.49* ) FLAGS="-Dusedevel" ;;
  * ) FLAGS="" ;;
esac

# get sources

curl_strict_sha256 \
  https://www.cpan.org/src/5.0/perl-$VERSION.tar.gz \
  $BASE_DIR/resources/perl-$VERSION.tar.gz.sha256

tar xf perl-$VERSION.tar.gz
pushd perl-$VERSION
  # build
  ./Configure -des -Dprefix=$PREFIX $FLAGS
  make -j`nproc`
  make install
popd

if [ ! -e /opt/wandbox/perl-$VERSION/bin/perl ]; then
  ln -s /opt/wandbox/perl-$VERSION/bin/perl$VERSION /opt/wandbox/perl-$VERSION/bin/perl
fi

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
