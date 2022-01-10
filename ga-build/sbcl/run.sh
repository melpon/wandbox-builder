#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  sudo apt-get install -y sbcl
  exit 0
fi

curl_strict_sha256 \
  https://downloads.sourceforge.net/project/sbcl/sbcl/$VERSION/sbcl-${VERSION}-source.tar.bz2 \
  $BASE_DIR/resources/sbcl-${VERSION}-source.tar.bz2.sha256

tar xf sbcl-${VERSION}-source.tar.bz2

pushd sbcl-${VERSION}
  # build
  export INSTALL_ROOT="$PREFIX"

  sh make.sh
  sh install.sh
popd

cp $BASE_DIR/resources/run-sbcl.sh.in $PREFIX/bin/run-sbcl.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-sbcl.sh
chmod +x $PREFIX/bin/run-sbcl.sh

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
