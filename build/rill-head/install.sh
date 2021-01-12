#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/rill-head

set -eux -o pipefail

# rill-head

cd ~/

if [ -e workspace ]; then
    rm -rf workspace
fi
mkdir workspace

# get sources

cd ~/workspace

git clone -b next --depth 1 https://github.com/yutopp/rill.git

# build and test rillc

cd ~/workspace/rill/rillc

opam repo add rillc-deps-opam-repo https://github.com/yutopp/rillc-deps-opam-repo.git
opam update
opam install . --deps-only --no-depexts --with-test -y --locked -j "$(nproc)"
make build
make test

# build all rill components

cd ~/workspace/rill

if [ -e build ]; then
    rm -rf build
fi
mkdir build

cd ~/workspace/rill/build

cmake .. -DCMAKE_INSTALL_PREFIX="$PREFIX" -DRILL_TARGET_TRIPLES="x86_64-unknown-linux-gnu"
make
make CTEST_OUTPUT_ON_FAILURE=1 test
make install
