#!/bin/bash

function show_help() {
  echo "$0 <URL> <output-name>.tar.gz"
  echo ""
  echo "example:"
  echo "  $0 https://llvm.org/svn/llvm-project/libcxxabi/branches/release_32/ clang/resources/libcxxabi-3.2.src.tar.gz"
}

if [ $# -lt 2 ]; then
  show_help
  exit 1
fi

if [ "${$2: -7}" != ".tar.gz" ]; then
  show_help
  exit 1
fi

set -ex

OUTPUT_PATH_TAR_GZ="$2"
OUTPUT_PATH_TAR="${OUTPUT_PATH_TAR_GZ%.*}"
OUTPUT_PATH="${OUTPUT_PATH_TAR%.*}"
DIRNAME=`basename "$OUTPUT_PATH"`

svn export "$1" "$DIRNAME"
tar -zcvf "$OUTPUT_PATH_TAR_GZ" "$DIRNAME"
rm -r $DIRNAME
