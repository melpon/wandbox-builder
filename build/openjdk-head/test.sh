#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/openjdk-head

cd $BASE_DIR/resources
$PREFIX/bin/javac test.java
test "`$PREFIX/bin/run-java.sh`" = "hello"
rm test.class
