#!/bin/bash

. ./init.sh

PREFIX=/opt/wandbox/lazyk

# build

mkdir -p $PREFIX/bin
g++ $BASE_DIR/resources/lazy.cpp -O2 -o $PREFIX/bin/lazyk

test_lazyk $PREFIX
