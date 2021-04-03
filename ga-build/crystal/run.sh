#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  sudo apt-get install -y \
    libbsd-dev \
    libedit-dev \
    libevent-dev \
    libgmp-dev \
    libgmpxx4ldbl \
    libssl-dev \
    libxml2-dev \
    libyaml-dev \
    automake \
    libtool \
    git \
    llvm-8 \
    llvm-8-dev \
    lld-8 \
    libpcre3-dev
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 09617FD37CC06B54
  sudo echo "deb https://dist.crystal-lang.org/apt crystal main" > /etc/apt/sources.list.d/crystal.list
  sudo apt-get update
  sudo apt-get install -y \
    crystal
  crystal --version
  exit 0
fi

# get source
wget_strict_sha256 \
  "https://github.com/crystal-lang/crystal/archive/${VERSION}.tar.gz" \
  "$BASE_DIR/resources/${VERSION}.tar.gz.sha256"
tar xf "${VERSION}.tar.gz"

# build
cd "crystal-${VERSION}/"
make -j`nproc` verbose=1

# install
mkdir -p "$PREFIX"
rm -rf "$PREFIX"/* "$PREFIX"/.[!.]*
cp -a ./. "$PREFIX"

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
