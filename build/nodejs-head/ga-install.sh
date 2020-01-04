#!/bin/bash

set -ex

apt-get update
apt-get install -y \
  g++ \
  gcc \
  git \
  make \
  python-minimal \
  wget

./install.sh
