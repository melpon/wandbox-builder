#!/bin/bash

set -ex

apt-get update
apt-get install -y \
  autoconf \
  clang \
  cmake \
  git \
  icu-devtools \
  libblocksruntime-dev \
  libbsd-dev \
  libcurl4-openssl-dev \
  libedit-dev \
  libicu-dev \
  libkqueue-dev \
  libncurses5-dev \
  libpython-dev \
  libsqlite3-dev \
  libtool \
  libxml2-dev \
  ninja-build \
  pkg-config \
  python \
  swig \
  systemtap-sdt-dev \
  uuid-dev

./install.sh
