#!/bin/bash

. ./init.sh

PREFIX=/opt/wandbox/perl-head

# get sources

cd ~/
git clone --depth 1 --branch blead git://perl5.git.perl.org/perl.git
cd perl

# build

./Configure -des -Dprefix=$PREFIX -Dusedevel

make -j2
make install

rm $PREFIX/bin/perl || true
ln -s $PREFIX/bin/perl5.* $PREFIX/bin/perl

test_perl $PREFIX
