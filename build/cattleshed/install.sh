#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/cattleshed

# get sources

cd ~/
git clone --branch master --depth 1 https://github.com/melpon/wandbox

# prepare

pushd wandbox
  ./install_tools.sh
popd

# build

pushd wandbox/cattleshed
  ./cmake.sh -DCMAKE_INSTALL_PREFIX=$PREFIX

  make -C _build -j2
  make -C _build install
popd
