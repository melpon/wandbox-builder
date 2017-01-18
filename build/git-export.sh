#!/bin/bash

function show_help() {
  echo "$0 <URL> <branch> <output-name>.tar.gz"
  echo ""
  echo "example:"
  echo "  $0 https://github.com/melpon/cppcms feature/1.0.5 kennel/resources/cppcms.tar.gz"
}

if [ $# -lt 3 ]; then
  show_help
  exit 1
fi

if [ "${$3: -7}" != ".tar.gz" ]; then
  show_help
  exit 1
fi

set -ex

OUTPUT_PATH_TAR_GZ="$3"
FULL_OUTPUT_PATH_TAR_GZ=$(cd $(dirname $OUTPUT_PATH_TAR_GZ) && pwd)/$(basename $OUTPUT_PATH_TAR_GZ)
OUTPUT_PATH_TAR="${OUTPUT_PATH_TAR_GZ%.*}"
OUTPUT_PATH="${OUTPUT_PATH_TAR%.*}"
DIRNAME=`basename "$OUTPUT_PATH"`

git clone --depth=1 --branch "$2" --single-branch "$1" "$DIRNAME"
cd $DIRNAME
git archive --format=tar.gz --prefix=$DIRNAME/ HEAD > $FULL_OUTPUT_PATH_TAR_GZ
cd ..
rm -rf $DIRNAME
