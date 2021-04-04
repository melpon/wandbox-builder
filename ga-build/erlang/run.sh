#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  sudo apt-get install -y \
    libssl-dev \
    ncurses-dev
  exit 0
fi

wget_strict_sha256 \
  https://github.com/erlang/otp/releases/download/OTP-$VERSION/otp_src_$VERSION.tar.gz \
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

make -j`nproc`
make install

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
