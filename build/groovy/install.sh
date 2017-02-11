#!/bin/bash

. ./init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/groovy-$VERSION
JAVA_PREFIX=/opt/wandbox/openjdk-jdk8u121-b13/jvm/openjdk-1.8.0-internal
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

VERSION_BRANCH=$(echo $VERSION | sed 's/\./_/g')

# get sources

cd ~/
git clone --depth 1 --branch GROOVY_$VERSION_BRANCH https://github.com/apache/groovy.git
cd groovy

# build

./gradlew clean distBin

if compare_version "$VERSION" ">=" "2.4.0"; then
  unzip target/distributions/apache-groovy-binary-$VERSION.zip
else
  unzip target/distributions/groovy-binary-$VERSION.zip
fi
rm -r $PREFIX || true
cp -r groovy-$VERSION $PREFIX

cp $BASE_DIR/resources/run-groovy.sh.in $PREFIX/bin/run-groovy.sh
sed -i "s#@java_prefix@#$JAVA_PREFIX#g" $PREFIX/bin/run-groovy.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-groovy.sh
chmod +x $PREFIX/bin/run-groovy.sh

test_groovy $PREFIX

rm -r ~/*
