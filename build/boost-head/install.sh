#!/bin/bash

. ./init.sh

if [ $# -lt 2 ]; then
  echo "$0 <version> <compiler>"
  exit 0
fi

VERSION=$1
COMPILER=$2

function check_version() {
  while read line; do
    if [ "$VERSION $COMPILER" = "$line" ]; then
      return 0
    fi
  done < VERSIONS
  return 1
}

check_version

PREFIX=/opt/wandbox/boost-$VERSION-$COMPILER
COMPILER_PREFIX=/opt/wandbox/$COMPILER
VERSION_TARNAME=$(echo $VERSION | sed 's/\./_/g')

# set flags

WITHOUTS="--without-mpi --without-signals --without-python --without-test"
ADDFLAGS=""
if [ $COMPILER = "clang-head" ]; then
  ADDFLAGS="<cxxflags>-Wno-unused-local-typedefs"
fi
if [ $COMPILER = "gcc-head" ]; then
  ADDFLAGS="$ADDFLAGS <cxxflags>-Wno-unused-local-typedefs"
  ADDFLAGS="$ADDFLAGS <cxxflags>-std=gnu++11"
  ADDFLAGS="$ADDFLAGS <cxxflags>-Wno-deprecated-declarations"
fi

# get sources

cd ~/
mkdir boost-$VERSION-$COMPILER
cd boost-$VERSION-$COMPILER

wget_strict_sha256 \
  http://downloads.sourceforge.net/project/boost/boost/$VERSION/boost_$VERSION_TARNAME.tar.gz \
  $BASE_DIR/resources/boost_$VERSION_TARNAME.tar.gz.sha256
tar xf boost_$VERSION_TARNAME.tar.gz
cd boost_$VERSION_TARNAME

# apply patches

if compare_version "$VERSION" "<=" "1.49.0"; then
  # https://www.tablix.org/~avian/blog/archives/2015/02/working_around_broken_boost_thread/
  if compare_version "$VERSION" ">=" "1.48.0"; then
    ADDITIONAL_FILE="libs/locale/src/posix/numeric.cpp libs/locale/src/win32/numeric.cpp"
  fi
  for file in boost/chrono/config.hpp \
              boost/chrono/detail/inlined/posix/chrono.hpp \
              boost/chrono/detail/inlined/posix/process_cpu_clocks.hpp \
              boost/chrono/detail/inlined/win/process_cpu_clocks.hpp \
              boost/compatibility/cpp_c_headers/ctime \
              boost/date_time/c_time.hpp \
              boost/python/detail/wrap_python.hpp \
              boost/smart_ptr/detail/yield_k.hpp \
              $ADDITIONAL_FILE; do
    sed "s/include <time.h>/include <time.h>\n#undef TIME_UTC/g" -i $file
  done
fi

if compare_version "$VERSION" "==" "1.54.0"; then
  patch -p1 -i $BASE_DIR/resources/boost-1.54.0-coroutine.patch
fi

if compare_version "$VERSION" ">=" "1.54.0"; then
  if compare_version "$VERSION" "<=" "1.55.0"; then
    patch -p2 -i $BASE_DIR/resources/boost-1.54.0-call_once_variadic.patch
  fi
fi

if compare_version "$VERSION" ">=" "1.51.0"; then
  if compare_version "$VERSION" "<=" "1.54.0"; then
    patch -p0 -i $BASE_DIR/resources/boost-1.51.0-__GLIBC_HAVE_LONG_LONG.patch
  fi
fi

# build

PATH=$COMPILER_PREFIX/bin:$PATH ./bootstrap.sh --prefix=$PREFIX
if [ "$COMPILER" = "clang-head" ]; then
  sed "s#using[ 	]*gcc.*;#using clang : : $COMPILER_PREFIX/bin/clang++ : <cxxflags>-I$COMPILER_PREFIX/include/c++/v1 <cxxflags>-nostdinc++ <linkflags>-L$COMPILER_PREFIX/lib $ADDFLAGS <linkflags>-stdlib=libc++ <linkflags>-Wl,-rpath,$COMPILER_PREFIX/lib ;#" -i project-config.jam
  ./b2 toolset=clang stage release link=shared runtime-link=shared $WITHOUTS -j2
  ./b2 toolset=clang install release link=shared runtime-link=shared $WITHOUTS --prefix=$PREFIX
else
  sed "s#using[ 	]*gcc.*;#using gcc : : $COMPILER_PREFIX/bin/g++ : <linkflags>-Wl,-rpath,$COMPILER_PREFIX/lib,-rpath,$COMPILER_PREFIX/lib64 ;#" -i project-config.jam
  ./b2 stage release link=shared runtime-link=shared $WITHOUTS -j2
  ./b2 install release link=shared runtime-link=shared $WITHOUTS --prefix=$PREFIX
fi

if [ "$COMPILER" = "clang-head" ]; then
  EXTRA_FLAGS="-lc++abi"
  test_boost_clang $PREFIX $COMPILER_PREFIX $EXTRA_FLAGS
else
  test_boost_gcc $PREFIX $COMPILER_PREFIX
fi

cd ~/
rm -r boost-$VERSION-$COMPILER
