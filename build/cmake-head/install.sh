#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/cmake-head

# get sources

cd ~/
git clone --depth 1 https://gitlab.kitware.com/cmake/cmake.git
cd cmake

# build

./bootstrap --prefix=$PREFIX
make -j2
rm -r $PREFIX || true
make install
