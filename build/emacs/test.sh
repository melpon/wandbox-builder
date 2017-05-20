#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/emacs-$VERSION

test "$($PREFIX/bin/emacs --script $BASE_DIR/resources/test.el)" = "hello"
