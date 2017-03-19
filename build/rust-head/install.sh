#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/rust-head

# get sources

cd ~/

git clone --depth 1 https://github.com/rust-lang/rust.git

cd rust

# apply patch

# build

./configure --prefix=$PREFIX
make -j2
make install
