#!/bin/bash

if [ $# -lt 1 ]; then
  echo "$0 <build>"
  exit 0
fi

set -e

. $(cd $(dirname $0); pwd)/init.sh

set +x

BUILD=$1
BASE_DIR=$BASE_DIR/$BUILD

cd $BASE_DIR

cat VERSIONS | while read line; do
  if [ "$line" != "" ]; then
    if ./test.sh $line < /dev/null > tmpresult 2>&1; then
      echo "$line: ok"
    else
      echo "$line: failed"
      cat tmpresult
    fi
    rm tmpresult || true
  fi
done
