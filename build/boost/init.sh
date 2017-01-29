#!/bin/bash

. ../init.sh

function test_boost_gcc() {
  boost_prefix=$1
  compiler_prefix=$2
  $compiler_prefix/bin/g++ \
    -I$boost_prefix/include \
    -L$boost_prefix/lib \
    -Wl,-rpath,$boost_prefix/lib \
    -lboost_serialization \
    -lboost_system \
    $BASE_DIR/resources/test.cpp && \
  ./a.out > /dev/null && \
  test "`./a.out`" = "`echo -e "23\n0\nSuccess"`" && \
  rm a.out
}

function test_boost_clang() {
  boost_prefix=$1
  compiler_prefix=$2
  extra_flags=$3
  $compiler_prefix/bin/clang++ \
    -I$compiler_prefix/include/c++/v1 \
    -L$compiler_prefix/lib -Wl,-rpath,$compiler_prefix/lib \
    -stdlib=libc++ \
    -nostdinc++ \
    -I$boost_prefix/include \
    -L$boost_prefix/lib \
    -Wl,-rpath,$boost_prefix/lib \
    -lboost_serialization \
    -lboost_system \
    $extra_flags \
    $BASE_DIR/resources/test.cpp && \
  ./a.out > /dev/null && \
  test "`./a.out`" = "`echo -e "23\n0\nSuccess"`" && \
  rm a.out
}

function install_if_not_exists() {
  version=$1
  compiler=$2
  compiler_version=$3
  if [ ! -d /opt/wandbox/boost-$version/$compiler-$compiler_version ]; then
    run_with_log 1 ./install.sh "$@"
  else
    echo "already installed boost-$version for $compiler-$compiler_version"
  fi
}
