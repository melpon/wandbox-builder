#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/go-head

# get sources

cd ~/
git clone --depth 1 https://github.com/golang/go.git

rm -rf $PREFIX || true
mv go $PREFIX

# build

cd $PREFIX/src

./make.bash
