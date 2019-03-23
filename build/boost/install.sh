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
COMPILER_PREFIX=/opt/wandbox/$COMPILER-$COMPILER_VERSION
VERSION_TARNAME=$(echo $VERSION | sed 's/\./_/g')

# set flags

if compare_version $VERSION "<=" "1.68.0"; then
  WITHOUTS="--without-mpi --without-signals --without-python --without-test"
else
  WITHOUTS="--without-mpi --without-python --without-test"
fi

ADDFLAGS=""
if [ $COMPILER = "clang" ]; then
  if compare_version $COMPILER_VERSION ">=" "3.4"; then
    ADDFLAGS="<cxxflags>-Wno-unused-local-typedefs"
  fi
fi
if [ $COMPILER = "gcc" ]; then
  if compare_version $COMPILER_VERSION ">=" "4.7.3"; then
    ADDFLAGS="$ADDFLAGS <cxxflags>-Wno-unused-local-typedefs"
  fi
  if compare_version $COMPILER_VERSION ">=" "4.8.1"; then
    ADDFLAGS="$ADDFLAGS <cxxflags>-std=gnu++11"
  fi
  if [ "$gccver" ">=" "5.1.0" ]; then
    ADDFLAGS="$ADDFLAGS <cxxflags>-Wno-deprecated-declarations"
  fi

  if compare_version $COMPILER_VERSION "<=" "5.3.0"; then
    if compare_version $VERSION "==" "1.64.0"; then
      WITHOUTS="$WITHOUTS --without-context --without-coroutine --without-fiber"
    fi
  fi
  if compare_version $COMPILER_VERSION ">=" "4.8.1"; then
    if compare_version $COMPILER_VERSION "<=" "4.8.5"; then
      if compare_version $VERSION "==" "1.58.0"; then
        WITHOUTS="$WITHOUTS --without-context --without-coroutine"
      fi
    fi
  fi
fi

# for zapcc settings

if [ "$COMPILER" = "zapcc" ]; then
  CLANG_COMPILER_PREFIX=/opt/wandbox/clang-head
  # create symlink zapcc to clang
  rm $COMPILER_PREFIX/bin/clang || true
  rm $COMPILER_PREFIX/bin/clang++ || true
  ln -s $COMPILER_PREFIX/bin/zapcc $COMPILER_PREFIX/bin/clang
  ln -s $COMPILER_PREFIX/bin/zapcc++ $COMPILER_PREFIX/bin/clang++
fi

# get sources

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

# apply patches

DIR=`pwd`
pushd $BASE_DIR
./apply-patch.sh $DIR $VERSION $COMPILER $COMPILER_VERSION
popd

# build

PATH=$COMPILER_PREFIX/bin:$PATH ./bootstrap.sh --prefix=$PREFIX
if [ "$COMPILER" = "clang" ]; then
  sed "s#using[ 	]*gcc.*;#using clang : : $COMPILER_PREFIX/bin/clang++ : <cxxflags>-I$COMPILER_PREFIX/include/c++/v1 <cxxflags>-nostdinc++ <linkflags>-L$COMPILER_PREFIX/lib $ADDFLAGS <linkflags>-stdlib=libc++ <linkflags>-Wl,-rpath,$COMPILER_PREFIX/lib ;#" -i project-config.jam
  ./b2 toolset=clang stage release link=shared runtime-link=shared $WITHOUTS -j2
  ./b2 toolset=clang install release link=shared runtime-link=shared $WITHOUTS --prefix=$PREFIX
elif [ "$COMPILER" = "zapcc" ]; then
  sed "s#using[ 	]*gcc.*;#using clang : : $COMPILER_PREFIX/bin/clang++ : <cxxflags>-I$CLANG_COMPILER_PREFIX/include/c++/v1 <cxxflags>-nostdinc++ <linkflags>-L$CLANG_COMPILER_PREFIX/lib $ADDFLAGS <linkflags>-stdlib=libc++ <linkflags>-Wl,-rpath,$CLANG_COMPILER_PREFIX/lib ;#" -i project-config.jam
  ./b2 toolset=clang stage release link=shared runtime-link=shared $WITHOUTS -j2
  ./b2 toolset=clang install release link=shared runtime-link=shared $WITHOUTS --prefix=$PREFIX
else
  sed "s#using[ 	]*gcc.*;#using gcc : : $COMPILER_PREFIX/bin/g++ : <linkflags>-Wl,-rpath,$COMPILER_PREFIX/lib,-rpath,$COMPILER_PREFIX/lib64 $ADDFLAGS ;#" -i project-config.jam
  ./b2 stage release link=shared runtime-link=shared $WITHOUTS -j2
  ./b2 install release link=shared runtime-link=shared $WITHOUTS --prefix=$PREFIX
fi

# clean

cd ~/
rm -r boost-$VERSION-$COMPILER-$COMPILER_VERSION

if [ "$COMPILER" = "zapcc" ]; then
  rm $COMPILER_PREFIX/bin/clang
  rm $COMPILER_PREFIX/bin/clang++
fi

# share boost header

cd $BASE_DIR
./share-boost-header.sh $VERSION $COMPILER $COMPILER_VERSION
