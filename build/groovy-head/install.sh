#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/groovy-head
JAVA_PREFIX=/opt/wandbox/openjdk-jdk-10+13/jvm/openjdk-10
export JAVA_HOME=/usr/lib/jvm/java-10-openjdk-amd64

# get sources

cd ~/
git clone --depth 1 https://github.com/apache/groovy.git
cd groovy

# build

./gradlew clean dist -x :groovy-binary:javadocAll

unzip subprojects/groovy-binary/build/distributions/apache-groovy-binary-*.zip
rm -r $PREFIX || true
cp -r groovy-* $PREFIX

cp $BASE_DIR/resources/run-groovy.sh.in $PREFIX/bin/run-groovy.sh
sed -i "s#@java_prefix@#$JAVA_PREFIX#g" $PREFIX/bin/run-groovy.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-groovy.sh
chmod +x $PREFIX/bin/run-groovy.sh

rm -r ~/*
