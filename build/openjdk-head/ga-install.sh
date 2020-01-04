#!/bin/bash

set -ex

apt-get update
apt-get build-dep -y \
  openjdk-8
apt-get install -y \
  mercurial \
  openjdk-8-jdk

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
