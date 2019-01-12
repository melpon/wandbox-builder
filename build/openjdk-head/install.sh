#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/openjdk-head
BOOTSTRAP_JDK="/opt/wandbox/openjdk-jdk-11+28/jvm/openjdk-11"

# get sources

cd ~/
hg clone http://hg.openjdk.java.net/jdk/jdk12 openjdk
cd openjdk

# build

bash configure --prefix=$PREFIX --with-memory-size=2048 --with-num-cores=3 --with-boot-jdk=$BOOTSTRAP_JDK
make images
make install

cp $BASE_DIR/resources/run-java.sh.in $PREFIX/bin/run-java.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-java.sh
chmod +x $PREFIX/bin/run-java.sh
