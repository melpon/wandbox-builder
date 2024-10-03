#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  sudo apt-get install -y \
    mercurial \
    openjdk-21-jdk \
    unzip \
    zip \
    libx11-dev \
    libxext-dev \
    libxrender-dev \
    libxrandr-dev \
    libxtst-dev \
    libxt-dev \
    libcups2-dev \
    libfontconfig1-dev \
    libasound2-dev
  exit 0
fi

# get sources
#
# find versions from
# - http://hg.openjdk.java.net/jdk-updates/jdk15u/tags
# - http://hg.openjdk.java.net/jdk-updates/jdk14u/tags

case "$VERSION" in
  "jdk-15.0.3+2" )
    JDK_MAJOR=15
    VERSION_FLAGS="--with-version-string=15.0.3+2"
    URL=http://hg.openjdk.java.net/jdk-updates/jdk15u ;;
  "jdk-14.0.2+12" )
    JDK_MAJOR=14
    VERSION_FLAGS="--with-version-string=14.0.2+12"
    URL=http://hg.openjdk.java.net/jdk-updates/jdk14u ;;
  * ) exit 1 ;;
esac

hg clone -r $VERSION $URL openjdk
pushd openjdk
  # build
  bash configure \
    --build=x86_64-linux-gnu \
    --prefix=$PREFIX \
    --with-num-cores=`nproc` \
    --with-boot-jdk=/usr/lib/jvm/java-14-openjdk-amd64 \
    $VERSION_FLAGS
  make JOBS=`nproc` images
  make JOBS=`nproc` install
popd

cp $BASE_DIR/resources/run-java.sh.in $PREFIX/bin/run-java.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-java.sh
chmod +x $PREFIX/bin/run-java.sh

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
