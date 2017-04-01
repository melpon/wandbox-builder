#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/openssl-$VERSION

test "`$PREFIX/bin/with-env.sh openssl genrsa 1024 | head -n 1`" = "-----BEGIN RSA PRIVATE KEY-----"
