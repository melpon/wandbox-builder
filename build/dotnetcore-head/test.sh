#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/dotnetcore-head

cd ~/
cp $BASE_DIR/resources/test.cs Program.cs
$PREFIX/bin/build-dotnet.sh
test "`$PREFIX/bin/run-dotnet.sh`" = "hello"
