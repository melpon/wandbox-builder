#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/vim-head

test `$PREFIX/bin/vim -X -N -u NONE -i NONE -V1 -e -s --cmd "redir! > /dev/stdout | source $BASE_DIR/resources/test.vim | redir END" +quit` = "hello"
