#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/cpython-$VERSION

if [ "$VERSION" = "head" ]; then
  PYTHON=$PREFIX/bin/python3
elif [ "$VERSION" = "2.7-head" ]; then
  PYTHON=$PREFIX/bin/python
else
  exit 1
fi

$PYTHON $BASE_DIR/resources/test.py > /dev/null
test "`$PYTHON $BASE_DIR/resources/test.py`" = "hello"
