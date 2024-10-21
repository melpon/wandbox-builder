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

# Go は以下のように Bootstrap を段階的にやっていく必要がある
#
# ref: https://go.dev/doc/install/source#go14
#
# Go <= 1.4: a C toolchain.
# 1.5 <= Go <= 1.19: a Go 1.4 compiler.
# 1.20 <= Go <= 1.21: a Go 1.17 compiler.
# 1.22 <= Go <= 1.23: a Go 1.20 compiler.
# Going forward, Go version 1.N will require a Go 1.M compiler, where M is N-2 rounded down to an even number. Example: Go 1.24 and 1.25 require Go 1.22.

function install_go() {
  TARGET_VERSION=$1
  TARGET_PREFIX=$2

  # get sources
  curl_strict_sha256 \
    https://dl.google.com/go/go$TARGET_VERSION.src.tar.gz \
    $BASE_DIR/resources/go$TARGET_VERSION.src.tar.gz.sha256

  tar xf go$TARGET_VERSION.src.tar.gz

  rm -rf $TARGET_PREFIX
  mkdir -p `dirname $TARGET_PREFIX`
  mv go $TARGET_PREFIX

  # build
  pushd $TARGET_PREFIX/src
    ./make.bash
  popd
}

if compare_version $VERSION '>=' '1.20'; then
  TARGET_VERSION=1.17
  TARGET_PREFIX=`pwd`/go-$TARGET_VERSION
  install_go $TARGET_VERSION $TARGET_PREFIX
  export GOROOT_BOOTSTRAP=$TARGET_PREFIX
fi

if compare_version $VERSION '>=' '1.22'; then
  TARGET_VERSION=1.20
  TARGET_PREFIX=`pwd`/go-$TARGET_VERSION
  install_go $TARGET_VERSION $TARGET_PREFIX
  export GOROOT_BOOTSTRAP=$TARGET_PREFIX

fi

if compare_version $VERSION '>=' '1.24'; then
  TARGET_VERSION=1.22
  TARGET_PREFIX=`pwd`/go-$TARGET_VERSION
  install_go $TARGET_VERSION $TARGET_PREFIX
  export GOROOT_BOOTSTRAP=$TARGET_PREFIX
fi

if compare_version $VERSION '>=' '1.26'; then
  TARGET_VERSION=1.24
  TARGET_PREFIX=`pwd`/go-$TARGET_VERSION
  install_go $TARGET_VERSION $TARGET_PREFIX
  export GOROOT_BOOTSTRAP=$TARGET_PREFIX
fi

install_go $VERSION $PREFIX

# https://github.com/docker-library/golang/blob/f30f0428221b94c7dcb414ebdcea83106df20897/1.13/alpine3.10/Dockerfile#L47-L53
rm -rf $PREFIX/pkg/bootstrap
rm -rf $PREFIX/pkg/obj

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
