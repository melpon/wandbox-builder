#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  sudo apt-get install -y \
    gettext \
    liblua5.3-dev \
    libperl-dev \
    python3-dev \
    ruby-dev \
    tcl-dev
  # symlink for lua5.3
  sudo ln -s /usr/include/lua5.3 /usr/include/lua
  sudo ln -s /usr/lib/x86_64-linux-gnu/liblua5.3.a /usr/lib/x86_64-linux-gnu/liblua.a
  sudo ln -s /usr/lib/x86_64-linux-gnu/liblua5.3-c++.a /usr/lib/x86_64-linux-gnu/liblua-c++.a
  exit 0
fi

git clone --depth 1 --branch v$VERSION https://github.com/vim/vim.git

pushd vim
  ./configure \
    --with-features=huge \
    --enable-perlinterp=yes \
    --enable-python3interp=yes \
    --enable-rubyinterp=yes \
    --enable-luainterp=yes \
    --enable-tclinterp=yes \
    --enable-fail-if-missing \
    --prefix=$PREFIX

  # apply patches for static link
  sed -e 's/-lperl/-Wl,-Bstatic -lperl -Wl,-Bdynamic/' -i src/auto/config.mk
  sed -e 's/-lieee//' -i src/auto/config.mk
  sed -e 's/-ltcl8.6/-Wl,-Bstatic -ltcl8.6 -Wl,-Bdynamic/' -i src/auto/config.mk

  make -j`nproc`
  make install
popd

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
