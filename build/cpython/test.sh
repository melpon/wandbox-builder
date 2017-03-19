#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/cpython-$VERSION

if compare_version "$VERSION" "<" "3.0.0"; then
  PYTHON=$PREFIX/bin/python
else
  PYTHON=$PREFIX/bin/python3
fi

$PYTHON $BASE_DIR/resources/test.py > /dev/null
test "`$PYTHON $BASE_DIR/resources/test.py`" = "hello"
