#!/bin/bash

/opt/wandbox/cattleshed/bin/cattlegrid \
  --rootdir=./jail \
  --mount=/bin,/etc,/lib,/lib64,/usr/bin,/usr/lib,/usr/include,/opt/wandbox \
  --rwmount=/tmp=./jail/tmp,/home/jail=./store \
  --devices=/dev/null,/dev/zero,/dev/full,/dev/random,/dev/urandom \
  --chdir=/home/jail \
  -- \
  /opt/wandbox/zapcc-1.0.1/bin/zapcc++ \
  -oprog.exe \
  -fcolor-diagnostics \
  -fansi-escape-codes \
  -I/opt/wandbox/clang-head/include/c++/v1 \
  -L/opt/wandbox/clang-head/lib \
  -Wl,-rpath,/opt/wandbox/clang-head/lib \
  -lpthread \
  -stdlib=libc++ \
  -nostdinc++ \
  -lc++abi \
  -DBOOST_NO_AUTO_PTR \
  prog.cc \
  -std=gnu++1z \
  -Wall \
  -Wextra
