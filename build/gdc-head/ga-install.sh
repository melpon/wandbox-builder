#!/bin/bash

set -ex

apt-get update
apt-get install -y \
  autoconf \
  automake \
  bison \
  flex \
  g++ \
  gcc \
  git \
  libgmp3-dev \
  libmpc-dev \
  libmpfr-dev \
  patch

./install.sh
