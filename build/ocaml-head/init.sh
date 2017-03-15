#!/bin/bash

. ../init.sh

function test_ocaml() {
  prefix=$1
  $prefix/bin/ocamlc $BASE_DIR/resources/test.ml -o test && test "`./test`" = "hello" && rm test && rm $BASE_DIR/resources/test.cmi && rm $BASE_DIR/resources/test.cmo
}
