#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  exit 0
fi


CURRENTURL="https://www.openssl.org/source/"
case "$VERSION" in
  "1.1.1k" )
    OLDURL="https://www.openssl.org/source/old/1.1.1/"
    FILENAME="openssl-1.1.1k.tar.gz"
    ;;
  "1.0.2u" )
    OLDURL="https://www.openssl.org/source/old/1.0.2/"
    FILENAME="openssl-1.0.2u.tar.gz"
    ;;
  "0.9.8zh" )
    OLDURL="https://www.openssl.org/source/old/0.9.x/"
    FILENAME="openssl-0.9.8zh.tar.gz"
    ;;
  * ) exit 1 ;;
esac

# get sources

curl_strict_sha256 \
  "${CURRENTURL}${FILENAME}" \
  $BASE_DIR/resources/openssl-$VERSION.tar.gz.sha256 || \
curl_strict_sha256 \
  "${OLDURL}${FILENAME}" \
  $BASE_DIR/resources/openssl-$VERSION.tar.gz.sha256

tar xf openssl-$VERSION.tar.gz

pushd openssl-$VERSION
  # build
  ./config --prefix=$PREFIX
  make -j`nproc`
  make install
popd

cp $BASE_DIR/resources/with-env.sh.in $PREFIX/bin/with-env.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/with-env.sh
chmod +x $PREFIX/bin/with-env.sh

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
