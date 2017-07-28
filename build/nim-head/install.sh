#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/nim-head

cd ~/

# get sources
git clone --depth 1 https://github.com/nim-lang/Nim.git

cd Nim
git submodule update --recursive --init
git clone --depth 1 https://github.com/nim-lang/csources.git

# build
cd csources
sh ./build.sh
cd ..
./bin/nim c koch
./koch boot -d:release

# install
./koch install /opt
rm -r "$PREFIX"
mv /opt/nim "$PREFIX"
