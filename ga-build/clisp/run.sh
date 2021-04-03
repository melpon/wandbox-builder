#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  apt-get install -y \
    libsigsegv-dev
  exit 0
fi

# get sources

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

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
