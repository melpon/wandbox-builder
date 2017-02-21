#!/bin/bash

set -ex

if [ $# -lt 2 ]; then
  echo "$0 <build> <url> [filename]"
  echo ""
  echo "example:"
  echo "  $0 clang http://www.llvm.org/releases/3.6.0/llvm-3.6.0.src.tar.xz"
  echo "  $0 php http://php.net/get/php-5.5.6.tar.gz/from/this/mirror php-5.5.6.tar.gz"
  exit 1
fi

BUILD=$1
URL=$2

if [ $# -ge 3 ]; then
  FILENAME=$3
else
  FILENAME=${URL##*/}
fi

wget $URL -O $FILENAME
sha256sum -b $FILENAME > $BUILD/resources/$FILENAME.sha256
rm $FILENAME
