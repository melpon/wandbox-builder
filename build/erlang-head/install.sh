#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/erlang-head

cd ~/

git clone --depth 1 --branch master https://github.com/erlang/otp.git

cd otp

./otp_build autoconf
./configure --prefix=$PREFIX \
            --enable-kernel-poll \
            --enable-dirty-schedulers \
            --enable-smp-support \
            --enable-m64-build \
            --enable-sharing-preserving \
            --without-javac \
            --disable-hipe \
            --disable-native-libs \
            --disable-vm-probes \
            --disable-megaco-flex-scanner-lineno \
            --disable-megaco-reentrant-flex-scanner \
            --disable-sctp

make -j2
make install

cp $BASE_DIR/resources/run-escript.sh.in $PREFIX/bin/run-escript.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-escript.sh
chmod +x $PREFIX/bin/run-escript.sh

cd ..
rm -rf ~/otp
