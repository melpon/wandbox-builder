#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/cmake-head

test "`$PREFIX/bin/cmake -P resources/test.cmake`" = "-- hello"
