#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/mono-head

cd ~/
mkdir mono-head
cd mono-head

# get sources

git clone --depth 1 https://github.com/mono/mono.git

# build

cd mono
./autogen.sh --prefix=$PREFIX --disable-nls

make -j2
make install

cd ~/
rm -r mono-head
