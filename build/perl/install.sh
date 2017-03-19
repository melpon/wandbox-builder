#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/perl-$VERSION

# devel version
if compare_version "$VERSION" "==" "5.25.10"; then
  FLAGS="-Dusedevel"
else
  FLAGS=""
fi

# get sources

cd ~/
wget_strict_sha256 \
  http://www.cpan.org/src/5.0/perl-$VERSION.tar.gz \
  $BASE_DIR/resources/perl-$VERSION.tar.gz.sha256

tar xf perl-$VERSION.tar.gz
cd perl-$VERSION

# build

./Configure -des -Dprefix=$PREFIX $FLAGS

make -j2
make install

if [ ! -e /opt/wandbox/perl-$VERSION/bin/perl ]; then
  ln -s /opt/wandbox/perl-$VERSION/bin/perl$VERSION /opt/wandbox/perl-$VERSION/bin/perl
fi

rm -r ~/*
