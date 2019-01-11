#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  echo "  find versions from http://hg.openjdk.java.net/jdk10/jdk10/tags"
  echo "                     http://hg.openjdk.java.net/jdk9/jdk9/tags"
  echo "                     http://hg.openjdk.java.net/jdk8u/jdk8u/tags"
  echo "                     http://hg.openjdk.java.net/jdk7u/jdk7u/tags"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/openjdk-$VERSION

# get sources

case "$VERSION" in
  "jdk-11+28" )
    VERSION_FLAGS="--with-version-string=11+28"
    URL=http://hg.openjdk.java.net/jdk/jdk11 ;;
  "jdk-10+23" )
    VERSION_FLAGS="--with-version-string=10+23"
    URL=http://hg.openjdk.java.net/jdk10/jdk10 ;;
  "jdk-10+13" )
    VERSION_FLAGS="--with-version-string=10+13"
    URL=http://hg.openjdk.java.net/jdk10/jdk10 ;;
  "jdk-9+181" )
    VERSION_FLAGS="--with-version-string=9+181"
    URL=http://hg.openjdk.java.net/jdk9/jdk9 ;;
  "jdk-9+175" )
    VERSION_FLAGS="--with-version-string=9+175"
    URL=http://hg.openjdk.java.net/jdk9/jdk9 ;;
  "jdk-9+155" )
    VERSION_FLAGS="--with-version-string=9+155"
    URL=http://hg.openjdk.java.net/jdk9/jdk9 ;;
  "jdk8u121-b13" )
    VERSION_FLAGS="--with-update-version=121 --with-build-number=b13 --with-milestone=fcs"
    URL=http://hg.openjdk.java.net/jdk8u/jdk8u ;;
  "jdk7u121-b00" )
    export JDK_VERSION="1.7.0_121"
    export JDK_MAJOR_VERSION="1"
    export JDK_MINOR_VERSION="7"
    export JDK_MICRO_VERSION="0_121"
    export MILESTONE="fcs"
    export BUILD_NUMBER="b00"
    export FULL_VERSION="1.7.0_121-b00"
    URL=http://hg.openjdk.java.net/jdk7u/jdk7u ;;
  * ) exit 1 ;;
esac

cd ~/
hg clone $URL openjdk
cd openjdk
bash get_source.sh
if [ "$VERSION" = "jdk7u121-b00" ]; then
  bash ./make/scripts/hgforest.sh checkout $VERSION
else
  bash ./common/bin/hgforest.sh checkout $VERSION
fi

# build

if [ "$VERSION" = "jdk7u121-b00" ]; then
  export LANG=C
  export ALT_BOOTDIR=/usr/lib/jvm/java-7-openjdk-amd64
  make sanity
  make
  rm -r $PREFIX || true
  cp -r build/linux-amd64 $PREFIX
else
  bash configure --prefix=$PREFIX --with-memory-size=2048 --with-num-cores=3 $VERSION_FLAGS
  make all
  rm -r $PREFIX || true
  make install
fi

cp $BASE_DIR/resources/run-java.sh.in $PREFIX/bin/run-java.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-java.sh
chmod +x $PREFIX/bin/run-java.sh

rm -r ~/openjdk
