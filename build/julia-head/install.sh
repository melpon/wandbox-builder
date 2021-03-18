#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/julia-head

# get sources

cd ~/
git clone git://github.com/JuliaLang/julia.git

cd julia
cp $BASE_DIR/resources/Make.user Make.user
# isnan undefined reference workarround
sed -i -e 's/\([^:]\)isnan/\1std::isnan/g' src/intrinsics.cpp
make -j4
make install

rm -r $PREFIX || true
cp -r julia-* $PREFIX
