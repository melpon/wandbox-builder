#!/bin/bash

. ../init.sh

function test_vim() {
  prefix=$1
  test `$prefix/bin/vim -X -N -u NONE -i NONE -V1 -e -s --cmd "redir! > /dev/stdout | source $BASE_DIR/resources/test.vim | redir END" +quit` = "hello"
}
