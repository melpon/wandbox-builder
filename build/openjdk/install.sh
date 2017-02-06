#!/bin/bash

. ./init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  echo "  find versions from http://hg.openjdk.java.net/jdk9/jdk9/tags"
  echo "                     http://hg.openjdk.java.net/jdk8u/jdk8u/tags"
  echo "                     http://hg.openjdk.java.net/jdk7u/jdk7u/tags"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/openjdk-$VERSION

# get sources

case "$VERSION" in
  "jdk-9+155" ) URL=http://hg.openjdk.java.net/jdk9/jdk9 ;;
  "jdk8u121-b13" ) URL=http://hg.openjdk.java.net/jdk8u/jdk8u ;;
  "jdk7u121-b00" ) URL=http://hg.openjdk.java.net/jdk7u/jdk7u ;;
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
  bash configure --prefix=$PREFIX --with-memory-size=2048 --with-num-cores=3
  make all
  make install
fi

cp $BASE_DIR/resources/run-java.sh.in $PREFIX/bin/run-java.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-java.sh
chmod +x $PREFIX/bin/run-java.sh

test_openjdk $PREFIX

rm -r ~/openjdk
