#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/rust-head

# get sources

cd ~/

git clone --depth 1 https://github.com/rust-lang/rust.git

cd rust

# apply patch

# config

cp ./config.toml.example ./config.toml
sed -i -e 's$#prefix = "/usr/local"$prefix = "'$PREFIX'"$' ./config.toml

# build

./x.py build -j2
rm -r $PREFIX || true
mkdir $PREFIX
# enable install commands:
#   ./x.py install analysis
#   ./x.py install cargo
#   ./x.py install rls
#   ./x.py install src
#   ./x.py install src/doc
#   ./x.py install src/librustc
#   ./x.py install src/libstd # default

./x.py install # src/libstd
./x.py install src/librustc
