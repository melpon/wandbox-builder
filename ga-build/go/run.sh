#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  exit 0
fi

# bootstrap
wget https://dl.google.com/go/go1.4-bootstrap-20171003.tar.gz
tar xf go1.4-bootstrap-20171003.tar.gz
rm go1.4-bootstrap-20171003.tar.gz
mv go go1.4
pushd go1.4/src
  ./make.bash
popd
export GOROOT_BOOTSTRAP=`pwd`/go1.4

# get sources

wget_strict_sha256 \
  https://dl.google.com/go/go$VERSION.src.tar.gz \
  $BASE_DIR/resources/go$VERSION.src.tar.gz.sha256

tar xf go$VERSION.src.tar.gz

rm -rf $PREFIX
mkdir -p `dirname $PREFIX`
mv go $PREFIX

# build

pushd $PREFIX/src
  ./make.bash
popd

# https://github.com/docker-library/golang/blob/f30f0428221b94c7dcb414ebdcea83106df20897/1.13/alpine3.10/Dockerfile#L47-L53
rm -rf $PREFIX/pkg/bootstrap
rm -rf $PREFIX/pkg/obj

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
