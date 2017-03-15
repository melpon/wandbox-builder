#!/bin/bash

. ./init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/ocaml-$VERSION

# get sources

VERSION_SHORT=${VERSION:0:4}

cd ~/
wget_strict_sha256 \
  http://caml.inria.fr/pub/distrib/ocaml-$VERSION_SHORT/ocaml-$VERSION.tar.gz \
  $BASE_DIR/resources/ocaml-$VERSION.tar.gz.sha256

tar xf ocaml-$VERSION.tar.gz
cd ocaml-$VERSION

# build

./configure -prefix $PREFIX
make world
make install

# version

test_ocaml $PREFIX
