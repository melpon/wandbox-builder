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

# https://github.com/docker-library/golang/blob/f30f0428221b94c7dcb414ebdcea83106df20897/1.13/alpine3.10/Dockerfile#L47-L53
rm -rf $PREFIX/pkg/bootstrap
rm -rf $PREFIX/pkg/obj
