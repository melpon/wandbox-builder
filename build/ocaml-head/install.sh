#!/bin/bash

. ./init.sh

PREFIX=/opt/wandbox/ocaml-head

# get sources

cd ~/
git clone --depth 1 https://github.com/ocaml/ocaml.git
cd ocaml
git submodule update --recursive -i

# build

./configure -prefix $PREFIX
make world
make install

# version

test_ocaml $PREFIX
