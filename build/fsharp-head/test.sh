#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/fsharp-head

cd ~/

$PREFIX/bin/run-fsharpc.sh $BASE_DIR/resources/test.fs --out:a.exe
$PREFIX/bin/run-mono.sh a.exe > /dev/null
test "`$PREFIX/bin/run-mono.sh a.exe`" = "hello"
rm a.exe
