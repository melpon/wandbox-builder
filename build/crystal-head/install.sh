#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/crystal-head

cd ~/

git clone --depth 1 https://github.com/crystal-lang/crystal.git
cd crystal/
git submodule update --recursive --init

# build
make clean verbose=1
make -j2 crystal verbose=1

# install
mkdir -p "$PREFIX"
rm -rf $PREFIX/* $PREFIX/.[!.]*
cp -a ./. "$PREFIX"
rm -rf "${PREFIX}/.git"
