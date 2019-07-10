#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/rust-head

# get sources

cd ~/

wget https://static.rust-lang.org/dist/rust-nightly-x86_64-unknown-linux-gnu.tar.gz
tar xf rust-nightly-x86_64-unknown-linux-gnu.tar.gz

cd rust-nightly-x86_64-unknown-linux-gnu

rm -r $PREFIX || true
mkdir $PREFIX

./install.sh --prefix=$PREFIX --components=rustc,rust-std-x86_64-unknown-linux-gnu
