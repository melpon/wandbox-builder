#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/openssl-head

# get sources

cd ~/

git clone --depth 1 https://github.com/openssl/openssl.git
cd openssl

# build

./config --prefix=$PREFIX
make
make install

cp $BASE_DIR/resources/with-env.sh.in $PREFIX/bin/with-env.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/with-env.sh
chmod +x $PREFIX/bin/with-env.sh
