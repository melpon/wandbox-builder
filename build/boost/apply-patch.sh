#!/bin/bash

. ./init.sh

if [ $# -lt 2 ]; then
  echo "$0 <boost-directory> <version>"
  exit 0
fi

cd $1

if [ ! -e "boost/chrono/config.hpp" ]; then
  echo "This script must run on boost library's root directory"
  exit 1
fi

VERSION=$2

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

if compare_version "$VERSION" "==" "1.66.0"; then
  patch -p1 -i $BASE_DIR/resources/boost-1.66.0-asio.patch
fi
if compare_version "$VERSION" ">=" "1.67.0"; then
  if compare_version "$VERSION" "<=" "1.68.0"; then
    patch -p2 -i $BASE_DIR/resources/boost-1.67.0-asio.patch
  fi
fi
