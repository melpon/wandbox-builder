#!/bin/bash

. ./init.sh

if [ $# -lt 2 ]; then
  echo "$0 <version> <compiler>"
  exit 0
fi

VERSION=$1
COMPILER=$2

check_version $VERSION $COMPILER

PREFIX=/opt/wandbox/boost-$VERSION/$COMPILER
HEADER_PREFIX=/opt/wandbox/boost-$VERSION/headers
VERSION_TARNAME=$(echo $VERSION | sed 's/\./_/g')

if [ ! -d "$HEADER_PREFIX" ]; then
  # no boost header directory exists
  cd ~/
  mkdir boost-$VERSION-$COMPILER
  cd boost-$VERSION-$COMPILER

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
  pushd $BASE_DIR/../boost
  if [ $COMPILER == "gcc-head" ]; then
    ./apply-patch.sh $DIR $VERSION gcc head
  elif [ $COMPILER == "clang-head" ]; then
    ./apply-patch.sh $DIR $VERSION clang head
  fi
  popd

  # install
  mkdir $HEADER_PREFIX
  cp -r boost $HEADER_PREFIX/boost

  # cleanup
  cd ~/
  rm -r boost-$VERSION-$COMPILER
fi

# share header

rm -r $PREFIX/include/boost || true
ln -s $HEADER_PREFIX/boost $PREFIX/include/boost
