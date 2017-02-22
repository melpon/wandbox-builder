#!/bin/bash

. ./init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/clisp-$VERSION

# get sources

cd ~/
wget_strict_sha256 \
  http://ftp.gnu.org/pub/gnu/clisp/release/$VERSION/clisp-$VERSION.tar.gz \
  $BASE_DIR/resources/clisp-$VERSION.tar.gz.sha256

tar xf clisp-$VERSION.tar.gz
cd clisp-$VERSION

# apply patches

sed -i 's/@LTLIBSIGSEGV@/-Wl,-Bstatic @LTLIBSIGSEGV@ -Wl,-Bdynamic/' src/makemake.in

# build

./configure --prefix=$PREFIX build
make -C build
make install -C build

test_clisp $PREFIX

rm -r ~/*
