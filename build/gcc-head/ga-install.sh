#!/bin/bash

set -ex

apt-get update
apt-get install -y \
  bison \
  build-essential \
  curl \
  flex \
  git \
  libc6-dev-i386 \
  libgmp-dev \
  libmpc-dev \
  libmpfr-dev \
  libtool \
  m4 \
  realpath \
  unzip \
  wget

./install.sh
