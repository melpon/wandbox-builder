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
