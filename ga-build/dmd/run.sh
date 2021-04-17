#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  exit 0
fi

# get sources

curl_strict_sha256 \
  http://downloads.dlang.org/releases/2.x/$VERSION/dmd.$VERSION.linux.tar.xz \
  $BASE_DIR/resources/dmd.$VERSION.linux.tar.xz.sha256
tar xf dmd.$VERSION.linux.tar.xz

# install

rm -rf $PREFIX
mkdir -p `dirname $PREFIX`
cp -r dmd2 $PREFIX

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
