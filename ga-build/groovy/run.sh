#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-triple.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  # download openjdk
  mkdir -p `dirname $COMPILER_PREFIX`
  pushd `dirname $COMPILER_PREFIX`
    curl -LO https://github.com/melpon/wandbox-builder/releases/download/assets-ubuntu-24.04/$COMPILER-$COMPILER_VERSION.tar.gz
    tar xf $COMPILER-$COMPILER_VERSION.tar.gz
  popd
  sudo apt install -y unzip
  exit 0
fi

export JAVA_HOME=$COMPILER_PREFIX/jvm/`cd $COMPILER_PREFIX/jvm/ && ls -1 | head -n1`

VERSION_BRANCH=$(echo $VERSION | sed 's/\./_/g')

# get sources
git clone --depth 1 --branch GROOVY_$VERSION_BRANCH https://github.com/apache/groovy.git
pushd groovy
  # build
  ./gradlew clean distBin
  unzip target/distributions/apache-groovy-binary-$VERSION.zip
  cp -r groovy-$VERSION $PREFIX
popd

cp $BASE_DIR/resources/run-groovy.sh.in $PREFIX/bin/run-groovy.sh
sed -i "s#@java_home@#$JAVA_HOME#g" $PREFIX/bin/run-groovy.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-groovy.sh
chmod +x $PREFIX/bin/run-groovy.sh

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
