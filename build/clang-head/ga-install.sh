#!/bin/bash

set -ex

apt-get update
apt-get install -y \
  build-essential \
  clang \
  clang-8 \
  coreutils \
  git \
  libc6-dev-i386 \
  libgmp-dev \
  libmpc-dev \
  libmpfr-dev \
  libstdc++-5-dev \
  libtool \
  python3 \
  wget

CMAKE_VERSION="3.16.3"
CMAKE_SHA256="3e15dadfec8d54eda39c2f266fc1e571c1b88bf32f9d221c8a039b07234206fa"

CMAKE_PREFIX="/usr/local/wandbox/camke-${CMAKE_VERSION}"

wget -q https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz
echo "${CMAKE_SHA256} *cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz" | sha256sum -c
tar xf cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz
mkdir -p /usr/local/wandbox/
mv cmake-${CMAKE_VERSION}-Linux-x86_64 $CMAKE_PREFIX

curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
export PATH="$HOME/.pyenv/bin:$PATH"
echo "eval $(pyenv init -)" >> ~/.bashrc
echo "eval $(pyenv virtualenv-init -)" >> ~/.bashrc
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv install 3.8.6
pyenv rehash
pyenv global 3.8.6

./install.sh
