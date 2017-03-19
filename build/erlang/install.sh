#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/erlang-$VERSION

cd ~/

wget_strict_sha256 \
  http://www.erlang.org/download/otp_src_$VERSION.tar.gz \
  $BASE_DIR/resources/otp_src_$VERSION.tar.gz.sha256

FLAGS=""

if compare_version "$VERSION" ">=" "19.0"; then
  FLAGS="$FLAGS --enable-sharing-preserving"
fi

tar xf otp_src_$VERSION.tar.gz
cd otp_src_$VERSION
./configure --prefix=$PREFIX \
            --enable-kernel-poll \
            --enable-hipe \
            --enable-dirty-schedulers \
            --enable-smp-support \
            --enable-m64-build \
            --without-javac \
            --disable-native-libs \
            --disable-vm-probes \
            --disable-megaco-flex-scanner-lineno \
            --disable-megaco-reentrant-flex-scanner \
            --disable-sctp \
            $FLAGS

make -j2
make install
cd ..
rm -rf otp_src_$VERSION
rm otp_src_$VERSION.tar.gz
