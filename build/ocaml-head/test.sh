#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/ocaml-head

cd $BASE_DIR/resources
$PREFIX/bin/with-env.sh ocamlfind ocamlopt -linkpkg -thread test.ml -o test
test "`./test`" = "Hello, world!"
rm test test.cmi test.cmx test.o
