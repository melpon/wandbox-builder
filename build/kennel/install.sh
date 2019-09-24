#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/kennel

# get sources

cd ~/
git clone --depth 1 https://github.com/melpon/wandbox

# prepare

pushd wandbox
  git submodule update -i
  ./install_tools.sh
popd

# build

pushd wandbox/kennel2
  ./cmake.sh -DCMAKE_INSTALL_PREFIX=$PREFIX

  make -C _build -j2
  make -C _build install
popd
