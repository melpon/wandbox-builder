#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  exit 0
fi

curl_strict_sha256 \
  https://ziglang.org/download/0.9.1/zig-linux-x86_64-$VERSION.tar.xz \
  $BASE_DIR/resources/zig-linux-x86_64-$VERSION.tar.xz

tar xf zig-linux-x86_64-$VERSION.tar.xz

cp -r zig-linux-x86_64-$VERSION $PREFIX

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
