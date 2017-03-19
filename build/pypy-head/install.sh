#!/bin/bash

. ../init.sh

VERSION=$1
PREFIX=/opt/wandbox/pypy-head

# get sources

cd ~/
wget http://buildbot.pypy.org/nightly/trunk/pypy-c-jit-latest-linux64.tar.bz2

mkdir pypy
tar xf pypy-c-jit-latest-linux64.tar.bz2 -C pypy --strip-components=1

# install

rm -r $PREFIX || true
cp -r pypy $PREFIX

# version

PYPY_VERSION=`/opt/wandbox/pypy-head/bin/pypy --version 2>&1 | tail -n 1 | cut -d' ' -f2`
CPYTHON_VERSION=`/opt/wandbox/pypy-head/bin/pypy --version 2>&1 | head -n 1 | cut -d' ' -f2`

echo "$PYPY_VERSION cpython-$CPYTHON_VERSION" > $PREFIX/VERSION

rm -r ~/*
