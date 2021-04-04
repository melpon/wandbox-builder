#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  exit 0
fi

if compare_version "$VERSION" ">=" "3.2.0"; then
  BINNAME=fpc-$VERSION-x86_64-linux
else
  BINNAME=fpc-$VERSION.x86_64-linux
fi

wget_strict_sha256 \
  https://downloads.sourceforge.net/project/freepascal/Linux/$VERSION/$BINNAME.tar \
  $BASE_DIR/resources/$BINNAME.tar.sha256

tar xf $BINNAME.tar
pushd $BINNAME
  ./install.sh < /dev/null
popd

# get sources

wget_strict_sha256 \
  https://downloads.sourceforge.net/project/freepascal/Source/$VERSION/fpc-$VERSION.source.tar.gz \
  $BASE_DIR/resources/fpc-$VERSION.source.tar.gz.sha256

tar xf fpc-$VERSION.source.tar.gz

# build

pushd fpc-$VERSION
  make build INSTALL_PREFIX=$PREFIX
  make install INSTALL_PREFIX=$PREFIX
popd

cp $BASE_DIR/resources/run-fpc.sh.in $PREFIX/bin/run-fpc.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-fpc.sh
chmod +x $PREFIX/bin/run-fpc.sh

# make symlink

ln -sf $PREFIX/lib/fpc/*/ppcx64 $PREFIX/bin/ppcx64

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
