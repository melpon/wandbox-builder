#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/openssl-$VERSION

case "$VERSION" in
  "1.1.0e" ) URL="https://www.openssl.org/source/openssl-1.1.0e.tar.gz" ;;
  "1.0.2k" ) URL="https://www.openssl.org/source/openssl-1.0.2k.tar.gz" ;;
  "1.0.1u" ) URL="https://www.openssl.org/source/old/1.0.1/openssl-1.0.1u.tar.gz" ;;
  "1.0.0s" ) URL="https://www.openssl.org/source/old/1.0.0/openssl-1.0.0s.tar.gz" ;;
  "0.9.8zh" ) URL="https://www.openssl.org/source/old/0.9.x/openssl-0.9.8zh.tar.gz" ;;
esac

# get sources

cd ~/

wget_strict_sha256 \
  $URL \
  $BASE_DIR/resources/openssl-$VERSION.tar.gz.sha256

tar xf openssl-$VERSION.tar.gz
cd openssl-$VERSION

# build

./config --prefix=$PREFIX
make
make install

cp $BASE_DIR/resources/with-env.sh.in $PREFIX/bin/with-env.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/with-env.sh
chmod +x $PREFIX/bin/with-env.sh
