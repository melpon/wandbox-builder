#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/kennel

# get sources

cd ~/
git clone --depth 1 https://github.com/melpon/wandbox

# prepare

pushd wandbox
  git submodule update -i
  ./install_deps.sh
popd

# build

pushd wandbox/kennel2
  ./cmake.sh --prefix $PREFIX

  make -C _build/release -j2
  make -C _build/release install
popd
