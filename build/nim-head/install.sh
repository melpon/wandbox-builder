#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/nim-head

cd ~/

# get sources
git clone --depth 1 https://github.com/nim-lang/Nim.git
cd Nim
# clones `csources.git`, bootstraps Nim compiler and compiles tools
sh build_all.sh

# install
./koch install /opt
rm -r "$PREFIX"
mv /opt/nim "$PREFIX"
