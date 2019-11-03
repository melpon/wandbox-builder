#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/go-$VERSION

# get sources

cd ~/
wget_strict_sha256 \
  https://github.com/golang/go/archive/go$VERSION.tar.gz \
  $BASE_DIR/resources/go$VERSION.tar.gz.sha256

tar xf go$VERSION.tar.gz

rm -rf $PREFIX || true
mv go-go$VERSION $PREFIX

# build

cd $PREFIX/src

./make.bash

# https://github.com/docker-library/golang/blob/f30f0428221b94c7dcb414ebdcea83106df20897/1.13/alpine3.10/Dockerfile#L47-L53
rm -rf $PREFIX/pkg/bootstrap
rm -rf $PREFIX/pkg/obj
