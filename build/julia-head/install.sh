#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/julia-head

# get sources

cd ~/
git clone git://github.com/JuliaLang/julia.git

cd julia
cp $BASE_DIR/resources/Make.user Make.user
# __NR_memfd_create disable workarround
# sed -i -e 's/ifdef __NR_memfd_create/ifdef __NR_memfd_create_disable/g' src/cgmemmgr.cpp
make -j4
make install

rm -r $PREFIX || true
cp -r julia-* $PREFIX

## nightly build
# wget https://julialangnightlies-s3.julialang.org/bin/linux/x64/julia-latest-linux64.tar.gz
# tar xf julia-latest-linux64.tar.gz
# rm -f julia-latest-linux64.tar.gz

# rm -r $PREFIX || true
# cp -r julia-* $PREFIX
