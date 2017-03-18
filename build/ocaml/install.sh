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
make world.opt
make install

# install opam

wget https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh
sh opam_installer.sh $PREFIX/bin

export PATH=$PREFIX/bin:$PATH
export OPAMROOT=$PREFIX/.opam
$PREFIX/bin/opam init < /dev/null
$PREFIX/bin/opam install -y core

# run ocaml

cp $BASE_DIR/resources/with-env.sh.in $PREFIX/bin/with-env.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/with-env.sh
chmod +x $PREFIX/bin/with-env.sh

test_ocaml $PREFIX
