#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/rill-head

set -ex

eval `opam config env`

rm -r $PREFIX
mkdir -p $PREFIX/bin

# llvm (only install)
PATH=/opt/llvm/bin:$PATH
cp /opt/llvm/bin/llc $PREFIX/bin/.
cp /opt/llvm/bin/llvm-config $PREFIX/bin/.

# rill-head

cd ~/
mkdir rill-head
cd rill-head

# get sources

git clone --depth 1 https://github.com/yutopp/rill.git

# build

cd rill
LIBRARY_PATH=/opt/llvm/bin
RILL_LLC_PATH=$PREFIX/bin/llc LIBRARY_PATH=$LIBRARY_PATH:$PREFIX/lib \
             omake RELEASE=true PREFIX=$PREFIX
RILL_LLC_PATH=$PREFIX/bin/llc LIBRARY_PATH=$LIBRARY_PATH:$PREFIX/lib \
             omake test
omake install

cd ~/
rm -r rill-head
