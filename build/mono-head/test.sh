#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/mono-head

cd ~/
$PREFIX/bin/mcs $BASE_DIR/resources/test.cs -out:a.out
$PREFIX/bin/mono a.out > /dev/null
test "`$PREFIX/bin/mono a.out`" = "hello"
rm a.out
