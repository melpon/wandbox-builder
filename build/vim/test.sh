#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/vim-$VERSION

test `$PREFIX/bin/vim -X -N -u NONE -i NONE -V1 -e -s --cmd "redir! > /dev/stdout | source $BASE_DIR/resources/test.vim | redir END" +quit` = "hello"
