#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/swift-head

cd ~/
$PREFIX/usr/bin/swiftc $BASE_DIR/resources/test.swift
test "`./test`" = "hello"
rm test
