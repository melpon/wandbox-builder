#!/bin/bash

set -ex

if [ $# -lt 2 ]; then
  echo "$0 <build> <url>"
  echo ""
  echo "example:"
  echo "  $0 clang http://www.llvm.org/releases/3.6.0/llvm-3.6.0.src.tar.xz"
  exit 1
fi

BUILD=$1
URL=$2

FILENAME=${URL##*/}

wget $URL
sha256sum -b $FILENAME > $BUILD/resources/$FILENAME.sha256
rm $FILENAME
