#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  exit 0
fi

MAJOR_MINOR=${VERSION%.*}

curl_strict_sha256 \
  https://julialang-s3.julialang.org/bin/linux/x64/$MAJOR_MINOR/julia-$VERSION-linux-x86_64.tar.gz \
  $BASE_DIR/resources/julia-$VERSION-linux-x86_64.tar.gz.sha256

tar xf julia-$VERSION-linux-x86_64.tar.gz

rm -rf $PREFIX
mkdir -p `dirname $PREFIX`
mv julia-$VERSION $PREFIX

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
