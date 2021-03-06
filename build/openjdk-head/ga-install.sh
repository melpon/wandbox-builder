#!/bin/bash

set -ex

apt-get update
apt-get install -y \
  build-essential \
  bzip2 \
  ca-certificates \
  ca-certificates-java \
  ccache \
  curl \
  g++ \
  gcc \
  git \
  libasound2-dev \
  libcups2-dev \
  libfreetype6-dev \
  libx11-dev \
  libxext-dev \
  libxrandr-dev \
  libxrender-dev \
  libxt-dev \
  libxtst-dev \
  make \
  mercurial \
  openjdk-8-jdk \
  pkg-config \
  ruby \
  ruby-dev \
  tar \
  unzip \
  zip

unset JAVA_TOOL_OPTIONS

# OpenJDK 10 からビルド
pushd ../openjdk
  ./install.sh jdk-10+23
popd

# OpenJDK 10 を使って OpenJDK 11 をビルド
pushd ../openjdk
  ./install.sh jdk-11+28
popd

# OpenJDK 11 を使って HEAD をビルド
./install.sh
