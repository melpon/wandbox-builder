#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  exit 0
fi

curl_strict_sha256 \
  https://ziglang.org/download/$VERSION/zig-linux-x86_64-$VERSION.tar.xz \
  $BASE_DIR/resources/zig-linux-x86_64-$VERSION.tar.xz.sha256

tar xf zig-linux-x86_64-$VERSION.tar.xz

mkdir -p `dirname $PREFIX`
cp -r zig-linux-x86_64-$VERSION $PREFIX

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
