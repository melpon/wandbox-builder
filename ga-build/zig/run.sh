#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  exit 0
fi

# 0.14.1以降ファイル名の付け方が変わっている
# https://ziglang.org/download/
if compare_version $VERSION ">=" "0.14.1"; then
  PLATFORM="x86_64-linux"
else
  PLATFORM="linux-x86_64"
fi

curl_strict_sha256 \
  https://ziglang.org/download/$VERSION/zig-$PLATFORM-$VERSION.tar.xz \
  $BASE_DIR/resources/zig-$PLATFORM-$VERSION.tar.xz.sha256

tar xf zig-$PLATFORM-$VERSION.tar.xz

mkdir -p `dirname $PREFIX`
cp -r zig-$PLATFORM-$VERSION $PREFIX

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
