#!/bin/bash

. ../init.sh

function test_ocaml() {
  prefix=$1
  cd $BASE_DIR/resources
  $prefix/bin/with-env.sh ocamlfind ocamlopt -linkpkg core -thread test.ml -o test && test "`./test`" = "Hello, world!" && rm test && rm test.cmi && rm test.cmo && rm test.cmi
}
