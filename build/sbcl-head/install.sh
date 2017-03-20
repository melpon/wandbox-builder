#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/sbcl-head

# get sources

cd ~/
git clone git://git.code.sf.net/p/sbcl/sbcl
cd sbcl

# apply patches

sed -i 's/with-timeout 10/with-timeout 60/g' contrib/sb-concurrency/tests/test-frlock.lisp

# build

export INSTALL_ROOT="$PREFIX"

sh make.sh
sh install.sh

cp $BASE_DIR/resources/run-sbcl.sh.in $PREFIX/bin/run-sbcl.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-sbcl.sh
chmod +x $PREFIX/bin/run-sbcl.sh

rm -r ~/*
