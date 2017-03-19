#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/ocaml-$VERSION

cd $BASE_DIR/resources
$PREFIX/bin/with-env.sh ocamlfind ocamlopt -linkpkg -package core -thread test.ml -o test
test "`./test`" = "Hello, world!"
rm test test.cmi test.cmx test.o
