#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/rust-head

# get sources

cd ~/

git clone --depth 1 https://github.com/rust-lang/rust.git

cd rust

# apply patch

# config

cp ./src/bootstrap/config.toml.example ./config.toml
sed -i -e 's$#prefix = "/usr/local"$prefix = "'$PREFIX'"$' ./config.toml

# build

./x.py build -j2
./x.py install
