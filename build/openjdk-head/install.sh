#!/bin/bash

. ./init.sh

PREFIX=/opt/wandbox/openjdk-head

# get sources

cd ~/
hg clone http://hg.openjdk.java.net/jdk10/jdk10 openjdk
cd openjdk
bash get_source.sh

# build

bash configure --prefix=$PREFIX --with-memory-size=2048 --with-num-cores=3
make all
make install

cp $BASE_DIR/resources/run-java.sh.in $PREFIX/bin/run-java.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-java.sh
chmod +x $PREFIX/bin/run-java.sh

test_openjdk $PREFIX
