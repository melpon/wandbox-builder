#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/r-head

# get sources

cd ~/
wget https://cran.r-project.org/src/base-prerelease/R-devel.tar.gz

tar xf R-devel.tar.gz
cd R-devel

# build

./configure --prefix=$PREFIX --without-readline --without-x

make -j2
rm -rf $PREFIX
make install

# version

echo `/opt/wandbox/r-head/bin/Rscript --version 2>&1 | cut -d' ' -f5,9,10` > $PREFIX/VERSION

rm -r ~/*
