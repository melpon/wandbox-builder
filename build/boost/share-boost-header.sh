#!/bin/bash

. ./init.sh

if [ $# -lt 3 ]; then
  echo "$0 <version> <compiler> <compiler_version>"
  exit 0
fi

VERSION=$1
COMPILER=$2
COMPILER_VERSION=$3

check_version $VERSION $COMPILER $COMPILER_VERSION

PREFIX=/opt/wandbox/boost-$VERSION/$COMPILER-$COMPILER_VERSION
HEADER_PREFIX=/opt/wandbox/boost-$VERSION/headers
VERSION_TARNAME=$(echo $VERSION | sed 's/\./_/g')

if [ ! -d "$HEADER_PREFIX" ]; then
  # no boost header directory exists
  cd ~/
  mkdir boost-$VERSION-$COMPILER-$COMPILER_VERSION
  cd boost-$VERSION-$COMPILER-$COMPILER_VERSION

  if compare_version $VERSION ">=" "1.65.0"; then
    URL=https://dl.bintray.com/boostorg/release/$VERSION/source/boost_$VERSION_TARNAME.tar.gz
  else
    URL=http://downloads.sourceforge.net/project/boost/boost/$VERSION/boost_$VERSION_TARNAME.tar.gz
  fi

  wget_strict_sha256 \
    $URL \
    $BASE_DIR/resources/boost_$VERSION_TARNAME.tar.gz.sha256
  tar xf boost_$VERSION_TARNAME.tar.gz
  cd boost_$VERSION_TARNAME

  # apply patch
  DIR=`pwd`
  pushd $BASE_DIR
  ./apply-patch.sh $DIR $VERSION
  popd

  # install
  mkdir $HEADER_PREFIX
  cp -r boost $HEADER_PREFIX/boost

  # cleanup
  cd ~/
  rm -r boost-$VERSION-$COMPILER-$COMPILER_VERSION
fi

# share header

rm -r $PREFIX/include/boost || true
ln -s $HEADER_PREFIX/boost $PREFIX/include/boost
