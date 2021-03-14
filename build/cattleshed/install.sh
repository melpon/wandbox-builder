#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/cattleshed

# get sources

cd ~/
git clone --branch master --depth 1 https://github.com/melpon/wandbox

# prepare

pushd wandbox
  ./install_deps.sh
popd

# build

pushd wandbox/cattleshed
  ./cmake.sh --prefix $PREFIX

  make -C _build/release -j2
  make -C _build/release install
popd
