#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/mruby-head

# get sources

cd ~/
git clone --depth 1 https://github.com/mruby/mruby.git
cd mruby

# config
sed -i -e "s#conf.gembox 'default'#conf.gembox 'full-core'#" build_config.rb

# build

./minirake
mkdir $PREFIX || true
cp -r bin $PREFIX

# get version

echo "`$PREFIX/bin/mruby --version | cut -d' ' -f2` (`git rev-parse --short HEAD`)" > $PREFIX/VERSION

rm -r ~/*
