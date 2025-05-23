#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  sudo apt-get install -y \
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

git clone --depth=1 -b $VERSION https://github.com/openjdk/jdk.git
pushd jdk
  # build
  bash configure \
    --build=x86_64-linux-gnu \
    --with-num-cores=`nproc` \
    --with-boot-jdk=/usr/lib/jvm/java-21-openjdk-amd64 \
    $VERSION_FLAGS
  make JOBS=`nproc` images
  mkdir -p $PREFIX/bin
  mkdir -p $PREFIX/jvm
  cp -r build/linux-x86_64-server-release/images/jdk $PREFIX/jvm/openjdk-$VERSION
  pushd $PREFIX/jvm/openjdk-$VERSION/bin
    BIN_FILES=`ls -1`
  popd
  for file in $BIN_FILES; do
    ln -s ../jvm/openjdk-$VERSION/bin/$file $PREFIX/bin/$file
  done
popd

cp $BASE_DIR/resources/run-java.sh.in $PREFIX/bin/run-java.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-java.sh
chmod +x $PREFIX/bin/run-java.sh

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
